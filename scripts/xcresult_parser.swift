#!/usr/bin/swift sh
import Foundation
import OBCoder  // @openbakery
import XCResultKit  // @davidahouse ~> 1.0.0

func printSeparator() {
	print(String(repeating: "=", count: 70))
}

func formatDuration(_ duration: Double) -> String {
	return String(format: "%.3f", duration)
}


func findFile(named filename: String, in directory: String = ".") -> String? {
	let fileManager = FileManager.default

	guard let enumerator = fileManager.enumerator(atPath: directory) else {
		return nil
	}

	while let file = enumerator.nextObject() as? String {
		if (file as NSString).lastPathComponent == filename {
			let fullPath = (directory as NSString).appendingPathComponent(file)
			return fullPath
		}
	}

	return nil
}


// MARK: - Test Results Processing

struct TestStats {
	var total: Int = 0
	var passed: Int = 0
	var failed: Int = 0
	var skipped: Int = 0
	var device: String = ""
}

struct Test {
	let suite: String
	let name: String
	let duration: Double?
	let failures: [TestFailure]

	var success: Bool { failures.count == 0 }
}

struct TestFailure: OBCoder.Encodable {
	let message: String
	let fileName: String?
	let lineNumber: Int?

	public init(message: String, fileName: String?, lineNumber: Int?) {
		self.message = message
		self.fileName = fileName
		self.lineNumber = lineNumber
	}

	init?(decoder: OBCoder.Decoder) {
		return nil
	}

	func encode(with coder: OBCoder.Coder) {
		coder.encode(message, forKey: "message")
		if let lineNumber {
			coder.encode(lineNumber, forKey: "line")
		}
	}


}

struct TestResult: OBCoder.Encodable {

	let filename: String
	var failures: [TestFailure]

	init(filename: String) {
		self.filename = filename
		self.failures = []
	}

	init?(decoder: OBCoder.Decoder) {
		return nil
	}

	func encode(with coder: OBCoder.Coder) {
		coder.encode(filename, forKey: "filename")
		coder.encode(failures, forKey: "failures")
		coder.encode(fullFilename, forKey: "fullFilename")
	}

	mutating func append(failure: TestFailure) {
		failures.append(failure)
	}

	var fullFilename: String {
		guard let name = filename.split(separator: "/").last else { return filename }
		if let file = findFile(named: String(name)) {
			return file
		}
		return filename
	}



}



func processGroup(_ node: ActionTestSummaryGroup, suite: String = "", stats: inout TestStats, tests: inout [Test], resultFile: XCResultFile) {

	// print("Group: \(node)")
	for group in node.subtestGroups {
		processGroup(group, suite: node.name ?? suite, stats: &stats, tests: &tests, resultFile: resultFile)
	}
	for test in node.subtests {
		processMetadata(test, suite: suite, stats: &stats, tests: &tests, resultFile: resultFile)
	}
}


// func measureTime(_ closure: () -> Void) {
// 	let start = CFAbsoluteTimeGetCurrent()
// 	closure()
// 	let end = CFAbsoluteTimeGetCurrent()
// 	print("Took \(end-start) seconds")
// }

func processMetadata(_ node: ActionTestMetadata, suite: String = "", stats: inout TestStats, tests: inout [Test], resultFile: XCResultFile) {

	// print("Metadata: \(node)")
	let status = node.testStatus

	stats.total += 1

	switch status {
		case "Success":
			stats.passed += 1
		// if let id = node.summaryRef?.id {
		// 	// print("nodel \(node)")
		// 	if let testSummary = resultFile.getActionTestSummary(id: id) {
		// 		// print("TestSummary \(testSummary)")
		// 		let test = Test(
		// 			suite: suite,
		// 			name: testSummary.identifier ?? node.identifier ?? "Unknown Test",
		// 			duration: testSummary.duration,
		// 			failures: []
		// 		)
		// 		tests.append(test)
		// 	}
		// }
		case "Failure":
			stats.failed += 1


			if let id = node.summaryRef?.id {
				if let testSummary = resultFile.getActionTestSummary(id: id) {

					var testFailures: [TestFailure] = []
					for failureSummary in testSummary.failureSummaries {

						let failure = TestFailure(
							message: failureSummary.message ?? "Unknown failure",
							fileName: failureSummary.fileName,
							lineNumber: failureSummary.lineNumber
						)
						testFailures.append(failure)
					}

					let test = Test(
						suite: suite,
						name: testSummary.identifier ?? node.identifier ?? "Unknown Test",
						duration: testSummary.duration,
						failures: testFailures
					)
					tests.append(test)


				}
			}
		case "Skipped", "Expected Failure":
			stats.skipped += 1
		default:
			break
	}

}


func printSummary(stats: TestStats) {
	printSeparator()
	print("TEST SUMMARY")
	printSeparator()
	print("Device:        \(stats.device)")
	print("Total Tests:   \(stats.total)")
	print("Passed:        \(stats.passed) ✓")
	print("Failed:        \(stats.failed) ✗")
	print("Skipped:       \(stats.skipped) ⊘")
	print()
}

func printFailingTests(_ tests: [Test]) {
	if tests.isEmpty {
		print("🎉 All tests passed!")
		return
	}

	var hasFailed = false
	for test in tests where !test.success {
		hasFailed = true
	}
	guard hasFailed else { return }

	printSeparator()
	print("FAILING TESTS")
	printSeparator()

	for (index, test) in tests.enumerated() {
		guard !test.success else { continue }
		print("\n\(index + 1). \(test.suite).\(test.name)")

		if let duration = test.duration {
			print("   Duration: \(formatDuration(duration))s")
		}

		for failure in test.failures {
			if let fileName = failure.fileName, let lineNumber = failure.lineNumber {
				print("   Location: \(fileName):\(lineNumber)")
			}
			print("   Message: \(failure.message)")
			print()
		}
	}
}

func saveJson(_ tests: [Test], filename: String) {

	var results = [String: TestResult]()
	for test in tests {
		for failure in test.failures {
			if let filename = failure.fileName {
				var result: TestResult = results[filename] ?? TestResult(filename: filename)
				result.append(failure: failure)
				results[filename] = result
			}
		}
	}

	let coder = JSONCoder()
	coder.encode(Array(results.values), forKey: "results")
	let fileURL = URL(fileURLWithPath: filename)
	do {
		try coder.jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
		// print("File saved successfully to: \(fileURL)")
	} catch {
		print("Error writing file: \(error)")
	}


}


func process(fileURL: URL, jsonFilename: String? = nil) -> Int {
	do {
		let resultFile = XCResultFile(url: fileURL)

		guard let invocationRecord = resultFile.getInvocationRecord() else {
			print("Error: Could not read invocation record")
			exit(1)
		}

		var stats = TestStats()
		var tests: [Test] = []

		// Process each action in the result
		for action in invocationRecord.actions {

			let device = action.runDestination.targetDeviceRecord
			stats.device = device.name
			guard let testReference = action.actionResult.testsRef else {
				continue
			}

			guard let testPlanSummaries = resultFile.getTestPlanRunSummaries(id: testReference.id) else {
				continue
			}

			// Process all test summaries
			for summary in testPlanSummaries.summaries {
				// print("summary: \(summary)")
				for testableSummary in summary.testableSummaries {
					// print("testableSummary: \(testableSummary)")
					for test in testableSummary.tests {
						processGroup(test, suite: testableSummary.name ?? "", stats: &stats, tests: &tests, resultFile: resultFile)
					}
				}
			}
		}

		if let jsonFilename {
			saveJson(tests, filename: jsonFilename)
		}

		// Print results
		printSummary(stats: stats)
		printFailingTests(tests)
		return tests.count

	} catch {
		print("Error parsing xcresult: \(error)")
		return 1
	}
}

func getXCResultFiles(in directory: String) -> [String] {
	let fileManager = FileManager.default

	do {
		let files = try fileManager.contentsOfDirectory(atPath: directory)
		let txtFiles = files.filter { $0.hasSuffix(".xcresult") }
		return txtFiles
	} catch {
		print("Error reading directory: \(error)")
		return []
	}
}

// MARK: - Main Script

guard CommandLine.arguments.count > 1 else {
	print("Usage: swift-sh xcresult_parser.swift <path_to_xcresult>")
	exit(1)
}

var jsonFilename: String?

let xcresultPath = CommandLine.arguments[1]

if CommandLine.arguments.count > 2 {
	if CommandLine.arguments[2] == "--json" {
		if CommandLine.arguments.count > 3 {
			jsonFilename = CommandLine.arguments[3]
		} else {
			jsonFilename = ".error.json"
		}
	}
}

let fileURL = URL(fileURLWithPath: xcresultPath)

guard FileManager.default.fileExists(atPath: xcresultPath) else {
	print("Error: File not found: \(xcresultPath)")
	exit(1)
}


if fileURL.pathExtension.lowercased() == "xcresult" {
	let result = process(fileURL: fileURL, jsonFilename: jsonFilename)
	if result > 0 {
		exit(1)
	}
	exit(0)
}


let directory = CommandLine.arguments[1]

let files = getXCResultFiles(in: fileURL.path)

for file in files {
	let url = fileURL.appendingPathComponent(file)
	// print("URL: \(url.path)")
	_ = process(fileURL: url, jsonFilename: jsonFilename)

}
