//
//  ApplicationMessages.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation

//MARK:- GENERAL

//Blank verification code: Verification code can’t be blank.”
//Invalid verification code: “Please enter valid verification code.”
//Incorrect verification code: “Entered verification code is incorrect.”

var CBtnYes:        String{ return CLocalize(text: "Yes") }
var CBtnNo:         String{ return CLocalize(text: "No") }
var CBtnOk:         String{ return CLocalize(text: "OK") }
var CBtnCancel:     String{ return CLocalize(text: "Cancel") }
var CBtnRetry:      String{ return CLocalize(text: "Retry") }
var CBtnSkip:       String{ return CLocalize(text: "Skip") }
var CBtnTryAgain:      String{ return CLocalize(text: "Try again") }
var CError: String{ return CLocalize(text: "ERROR!") }

var CMessageDelete: String{ return CLocalize(text: "Are you sure want to delete?") }
var CMessageLogout: String{ return CLocalize(text: "Are you sure want to logout?") }



let CBlankEmailOrMobileMessage          = "Email / mobile number can’t be blank."
let CBlankPasswordMessage               = "Password can’t be blank."
let CInvalidEmailMessage                = "Email is invalid."
let CInvalidMobileMessage               = "Mobile Number is invalid."
let CBlankFirstNameMessage              = "First Name can’t be blank."
let CBlankLastNameMessage               = "Last Name can’t be blank."
let CBlankEmailMessage                  = "Email can’t be blank."
let CBlankConfirmPasswordMessage        = "Confirm Password can’t be blank."
let CInvalidPasswordMessage             = "Password must be minimum 6 character alphanumeric."
let CMisMatchPasswordMessage            = "Password and Confirm Password doesn’t match."
let CTermsConditionNotAcceptedMessage   = "Please accept Terms & Conditions."
let CBlankOTPMessage                    = "OTP can’t be blank."
let CBlankNewPasswordMessage            = "New Password can’t be blank."
let CBlankVerificationCodeMessage        = "OTP can’t be blank."




