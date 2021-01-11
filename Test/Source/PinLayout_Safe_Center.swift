//
// Created by René Pirringer on 08.01.21.
// Copyright (c) 2021 org.openbakery. All rights reserved.
//


import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

@available(iOS 11, *)
class PinLayout_Safe_Center: PinLayout_Base_Test {


	// MARK: center X

	func test_view_is_horizontal_center() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = pinLayout.centerX(view: view)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	func test_view_is_horizontal_center_with_offset() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = pinLayout.centerX(view: view, offset: 20)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.constant, presentAnd(equalTo(20)))
	}

	func test_view_is_horizontal_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		let constraint = pinLayout.centerX(view: view, with:other)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}

	// MARK: center Y
	func test_view_is_vertical_center() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = pinLayout.centerY(view: view)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	func test_view_is_vertical_center_with_offset() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = pinLayout.centerY(view: view, offset: 20)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.constant, presentAnd(equalTo(20)))
	}


	func test_view_is_vertical_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		let constraint = pinLayout.centerY(view: view, with:other)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	// MARK: - safeCenter

	func test_saveArea_center() {
		let superview = UIView()
		superview.addSubview(view)

		let constraints = pinLayout.center(view: view)

		// then
		assertThat(constraints, hasCount(2))
		assertThat(constraints.first?.firstAttribute, equalTo(.centerX))
		assertThat(constraints.last?.firstAttribute, equalTo(.centerY))

		assertThat(constraints.first?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraints.last?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
	}


	func test_saveArea_center_to_other() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		let constraints = pinLayout.center(view: view, with: other)

		// then
		assertThat(constraints, hasCount(2))
		assertThat(constraints.first?.firstAttribute, equalTo(.centerX))
		assertThat(constraints.last?.firstAttribute, equalTo(.centerY))

		assertThat(constraints.first?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraints.last?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
	}



}
