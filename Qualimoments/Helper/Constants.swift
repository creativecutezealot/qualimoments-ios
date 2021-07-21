//
//  Constants.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation

class Constants {
    /////////////////////////URLS///////////////////////////
    
    static let BASE_URL =                   "https://apistaging.techtify.dk/qualiengine/v1"
    static let LOGIN =                      BASE_URL + "/auth"
    static let REGISTER =                   BASE_URL + "/reg"
    static let UPDATE_TOKEN =               BASE_URL + "/updateTokens"
    static let SEARCH_BY_NAME =             BASE_URL + "/protected/network/search"
    static let GET_POSSIBLE_PEOPLE =        BASE_URL + "/protected/network/possible"
    static let GET_FRIENDS =                BASE_URL + "/protected/network/friends"
    static let GET_MY_PROFILE =             BASE_URL + "/protected/profile/current"
    static let PROFILE_IMAGE =              BASE_URL + "/protected/profile/avatar"
    static let CHANGE_PROFILE =             BASE_URL + "/protected/profile/current"
    static let GET_NOTIFICATIONS =          BASE_URL + "/protected/notification/list"
    static let CONNECT_PEOPLE =             BASE_URL + "/protected/network/"
    static let DISCONNECT_PEOPLE =          BASE_URL + "/protected/network/"
    static let REGISTER_PUSH_TOKEN =        BASE_URL + "/protected/notification/"
    static let SEND_MESSAGE =               BASE_URL + "/protected/chat/"
    static let GET_MYPOSTS =                BASE_URL + "/protected/travel/posts"
    static let GET_MESSAGES =               BASE_URL + "/protected/chat/incoming"
    static let READ_MESSAGE =               BASE_URL + "/protected/chat/read/"
    static let CREATE_NEW_POST =            BASE_URL + "/protected/travel/posts"
    static let GET_CITIES =                 BASE_URL + "/public/cities"
    static let GET_NEWSFEED =               BASE_URL + "/protected/travel/newsFeed"
    static let GET_CATEGORIES =             BASE_URL + "/protected/travel/categories/"
    static let LIKE_POST =                  BASE_URL + "/protected/travel/posts/"
    static let LIKE_REVIEW =                BASE_URL + "/protected/travel/reviews/"
    static let UPDATE_TOURS =               BASE_URL + "/protected/profile/current/tours"
    static let GET_USER_TOURS =             BASE_URL + "/protected/profile/"
    static let POST_REPORT =                BASE_URL + "/reports"
    static let POST_RECOMMEND =             BASE_URL + "/protected/chat/recommend/"
    static let GET_PLACES =                 BASE_URL + "/protected/travel/places/"
    static let GET_PLACE_REVIEWS =          BASE_URL + "/protected/travel/reviews/"
    static let GET_MESSAGES_CHAT =          BASE_URL + "/protected/chat/"
    
    ////////////////////////Notification Type///////////////////////////
    static let NOTIFICATION_LIKE =          "notification_like_key";
    static let NOTIFICATION_COMMENT =       "notification_comment_key";
    
    static let NOTIFICATION_NEW_POST =      "notification_new_post_title"
    static let NOTIFICATION_FOLLOW =        "notification_start_following_title"
    static let NOTIFICATION_REVIEW =        "notification_new_review_title"
}
