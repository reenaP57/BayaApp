//
//  ApplicationMessages.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation


//MARK:-================== GENERAL =========================
//MARK:-


var CBtnYes         : String{ return CLocalize(text: "Yes") }
var CBtnNo          : String{ return CLocalize(text: "No") }
var CBtnOk          : String{ return CLocalize(text: "Ok") }
var CBtnCancel      : String{ return CLocalize(text: "Cancel") }
var CBtnRetry       : String{ return CLocalize(text: "Retry") }
var CBtnSkip        : String{ return CLocalize(text: "Skip") }
var CBtnTryAgain    : String{ return CLocalize(text: "Try again") }
var CError          : String{ return CLocalize(text: "ERROR!") }

var CMessageDelete: String{ return CLocalize(text: "Are you sure want to delete?") }
var CMessageLogout: String{ return CLocalize(text: "Are you sure want to logout?") }



//MARK:-================== LRF =========================
//MARK:-


var CBlankEmailOrMobileMessage  : String{ return CLocalize(text: "Email/mobile number can’t be blank.") }
var CBlankPasswordMessage       : String{ return CLocalize(text: "Password can’t be blank.") }
var CInvalidEmailMessage        : String{ return CLocalize(text: "Email is invalid.") }
var CInvalidMobileMessage       : String{ return CLocalize(text: "Mobile Number is invalid.") }
var CBlankMobileMessage         : String{ return CLocalize(text: "Mobile Number can’t be blank.") }
var CBlankFirstNameMessage      : String{ return CLocalize(text: "First Name can’t be blank.") }
var CBlankLastNameMessage       : String{ return CLocalize(text: "Last Name can’t be blank.") }
var CBlankEmailMessage          : String{ return CLocalize(text: "Email can’t be blank.") }
var CBlankConfirmPasswordMessage: String{ return CLocalize(text: "Confirm Password can’t be blank.") }
var CInvalidPasswordMessage     : String{ return CLocalize(text: "Password must be minimum 6 character alphanumeric.") }
var CInvalidNewPasswordMessage     : String{ return CLocalize(text: "New Password must be minimum 6 character alphanumeric.") }

var CMisMatchPasswordMessage        : String{ return CLocalize(text: "Password and Confirm Password doesn’t match.") }
var CMisMatchNewPasswordMessage        : String{ return CLocalize(text: "New Password and Confirm Password doesn’t match.") }
var CTermsConditionNotAcceptedMessage: String{ return CLocalize(text: "Please accept Terms & Conditions.") }
var CBlankOTPMessage                : String{ return CLocalize(text: "OTP can’t be blank.") }
var CBlankNewPasswordMessage        : String{ return CLocalize(text: "New Password can’t be blank.") }
var CBlankVerificationCodeMessage   : String{ return CLocalize(text: "Verification Code can’t be blank.") }
var CInvalidVerificationCodeMessage : String{ return CLocalize(text: "Please enter valid verification code.") }
var CBlankOldPasswordMessage        : String{ return CLocalize(text: "Old Password can’t be blank.") }
var CBlankCurrentPasswordMessage    : String{ return CLocalize(text: "Current Password can’t be blank.") }
var CInvalidOTPMessage              : String{ return CLocalize(text: "OTP is invalid.") }



//MARK:-================== Schedule Visit =========================
//MARK:-


var CBlankTimeSlot1Message        : String{ return CLocalize(text: "Time Slot 1 can’t be blank.") }
var CBlankTimeSlot2Message        : String{ return CLocalize(text: "Time Slot 2 can’t be blank.") }
var CBlankTimeSlot3Message        : String{ return CLocalize(text: "Time Slot 3 can’t be blank.") }
var CBlankPurposeOfVisitMessage   : String{ return CLocalize(text: "Purpose of visit can’t be blank.") }
var CBlankNoOfGuestMessage        : String{ return CLocalize(text: "Please select number of guests to expect.") }
var CSelectProjectMessage        : String{ return CLocalize(text: "Please select the project you would like to visit.") }
var CDuplicateTimeSlotMessage        : String{ return CLocalize(text: "This time slot has already been added, please select different time slot.") }
var CInvalidTimeRangeMessage        : String{ return CLocalize(text: "Time slot should be between 10 am to 6:30 pm.") }
var CInvalidGapBetweenTimeSlotMessage        : String{ return CLocalize(text: "Time slot should be 24 hours from current time.") }


var CBlankFeedbackSupport        : String { return CLocalize(text:"Feedback can’t be blank.")} 
var CSelectRating                : String { return CLocalize(text:"Please add ratings.")}
var CBlankFeedbackVisit          : String { return CLocalize(text:"Please enter feedback on your visit.")}


var CLogOutMessage : String{ return CLocalize(text: "Are you sure you want to Logout?") }

//var CUnsubscribeMessage : String{ return CLocalize(text: "Are you sure you want to unsubscribe this project? You will not get any updates from this project on unsubscribing.") }

var CSuccessRateVisitMessage : String { return CLocalize(text: "Thank you for the review. Your review is valuable to us.")}

var CSuccessScheduleVisitMessage : String { return CLocalize(text: "The schedule visit request has been sent and you will get the update soon.")}

var CVerifyNoteMessage : String { return CLocalize(text: "Please enter verification code that we have sent you on your")}

var CProjectBrochureMessage : String { return CLocalize(text: "Your request is on the way and you will get the brochure in your inbox soon.")}

var CSuccessSupportMessage : String { return CLocalize(text: "Support request has been sent successfully.")}

var CSubscribeMessage  : String { return CLocalize(text: "You will now receive notifications for updates about this project.")}

var CUnsubscribeMessage  : String { return CLocalize(text: "You will no longer receive notifications for project updates.")}


var CEnablePushNotificationMessage  : String { return CLocalize(text: "Are you sure you want to enable Push Notifications?")}
var CDisablePushNotificationMessage  : String { return CLocalize(text: "Are you sure you want to disable Push Notifications?")}
var CEnableEmailNotificationMessage  : String { return CLocalize(text: "Are you sure you want to enable Email Notifications?")}
var CDisableEmailNotificationMessage  : String { return CLocalize(text: "Are you sure you want to disable Email Notifications?")}
var CEnableSMSNotificationMessage  : String { return CLocalize(text: "Are you sure you want to enable SMS Notifications?")}
var CDisableSMSNotificationMessage  : String { return CLocalize(text: "Are you sure you want to disable SMS Notifications?")}

var CResetMessage  : String { return CLocalize(text: "You might have got verification code on entered")}

var CResetCodeEmailMessage  : String { return CLocalize(text: "Verification code has been resent on your email address")}
var CResetCodeMobileMessage  : String { return CLocalize(text: "Verification code has been resent on your mobile number")}

var CMessageStartDate : String{ return CLocalize(text: "Please select start date.") }
var CMessageEndDate : String{ return CLocalize(text: "Please select end date.") }
var CMessageCompareFilterDate : String{ return CLocalize(text: "End date cannot be less than start date") }



var CMessageRequested  = "We have received your request for a visit. We will get back to you soon."
var CMessageCompleted  = "You have visited this project on"
var CMessageScheduled  = "Your visit has been scheduled for"
var CMessageRescheduled  = "Your visit has been rescheduled for"

var CBlankDocumentName      =  "Document name can’t be blank."
var CBlankDocMsg            =  "Message can't be blank."
var CSelectMaintenanceType  =  "Select the maintenance type."
var CBlankSubject           =  "Subject can't be blank."

var CBlankPassword        =  "Password can't be blank."
var CInvalidPassword      =  "Password is invalid."
var CBlankAmountToPay     =  "Amount to pay can’t be blank."



var CBlankReferredName    =  "Name can't be blank."
var CBlankReferEmail      =  "Email Address can't be blank."
var CValidEmailForRefer   =  "Email Address is invalid."
var CValidPhone           =  "Mobile Number should only be in 10 digit numeric format."
var CAcceptTermsCondition = "Please accept the Terms & Conditions of the referral system."
