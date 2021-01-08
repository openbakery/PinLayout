//
//  PinLayout_Center_Test.swift
//  PinLayoutTests
//
//  Created by René Pirringer on 08.01.21.
//  Copyright © 2021 org.openbakery. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

class PinLayout_Center_Test: PinLayout_Base_Test {
	
	// MARK: - horizontal equal

	func test_view_is_horizontal_center() {
		let superview = UIView()
		superview.addSubview(view)
		
		let constraint = pinLayout.horizontalCenter(view: view)

		
		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(superview))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
	}

	
	func test_view_is_horizontal_center_with_Float_offset() {
		let superview = UIView()
		superview.addSubview(view)
		
		let constraint = pinLayout.horizontalCenter(view: view, offset: 10)

		
		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
	}
	
	func test_view_is_horizontal_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)
		
		let constraint = pinLayout.horizontalCenter(view: view, toView: other)

		
		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(other))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
	}
	
	
	func test_view_is_horizontal_center_with_other_view_with_offset() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)
		
		let constraint = pinLayout.horizontalCenter(view: view, toView: other, offset: 10)

		
		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
	}
	
	
	// MARK: - vertical equal
	
	func test_view_is_vertical_center() {
		let superview = UIView()
		superview.addSubview(view)
		
		let constraint = pinLayout.verticalCenter(view: view)

		
		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(superview))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
	}

	
	func test_view_is_vertical_center_with_Float_offset() {
		let superview = UIView()
		superview.addSubview(view)
		
		let constraint = pinLayout.verticalCenter(view: view, offset: 10)

		
		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
	}
	
	func test_view_is_vertical_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)
		
		let constraint = pinLayout.verticalCenter(view: view, toView: other)

		
		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(other))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
	}
	
	
	func test_view_is_vertical_center_with_other_view_with_offset() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)
		
		let constraint = pinLayout.verticalCenter(view: view, toView: other, offset: 10)

		
		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
	}
	
	

}
