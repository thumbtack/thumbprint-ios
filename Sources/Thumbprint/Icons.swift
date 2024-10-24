import UIKit

public enum Icon: String, CaseIterable, Sendable {
    public enum Size: String, CaseIterable {
        case tiny = "--tiny"
        case small = "--small"
        case medium = "--medium"

        public var dimension: CGFloat {
            switch self {
            case .tiny:
                14
            case .small:
                18
            case .medium:
                28
            }
        }
    }

    /// *Must* be called before attempting to reference any icons.
    public static func register(bundle: Bundle) {
        Self.bundle = bundle
    }

    case contentActionsAddMedium = "contentActions_add--medium"
    case contentActionsAddSmall = "contentActions_add--small"
    case contentActionsArchiveMedium = "contentActions_archive--medium"
    case contentActionsArchiveSmall = "contentActions_archive--small"
    case contentActionsArchiveFilledSmall = "contentActions_archive-filled--small"
    case contentActionsAttachMedium = "contentActions_attach--medium"
    case contentActionsAttachSmall = "contentActions_attach--small"
    case contentActionsAttachTiny = "contentActions_attach--tiny"
    case contentActionsAudioMedium = "contentActions_audio--medium"
    case contentActionsAudioSmall = "contentActions_audio--small"
    case contentActionsBudgetMedium = "contentActions_budget--medium"
    case contentActionsBudgetSmall = "contentActions_budget--small"
    case contentActionsCheckMedium = "contentActions_check--medium"
    case contentActionsCheckSmall = "contentActions_check--small"
    case contentActionsCheckTiny = "contentActions_check--tiny"
    case contentActionsCopyLinkMedium = "contentActions_copy-link--medium"
    case contentActionsCopyLinkSmall = "contentActions_copy-link--small"
    case contentActionsEditMedium = "contentActions_edit--medium"
    case contentActionsEditSmall = "contentActions_edit--small"
    case contentActionsEditTiny = "contentActions_edit--tiny"
    case contentActionsExportMedium = "contentActions_export--medium"
    case contentActionsExportSmall = "contentActions_export--small"
    case contentActionsFilterMedium = "contentActions_filter--medium"
    case contentActionsFilterSmall = "contentActions_filter--small"
    case contentActionsFlagMedium = "contentActions_flag--medium"
    case contentActionsFlagSmall = "contentActions_flag--small"
    case contentActionsFolderMedium = "contentActions_folder--medium"
    case contentActionsFolderSmall = "contentActions_folder--small"
    case contentActionsGestureMedium = "contentActions_gesture--medium"
    case contentActionsImageMedium = "contentActions_image--medium"
    case contentActionsImageSmall = "contentActions_image--small"
    case contentActionsImageTiny = "contentActions_image--tiny"
    case contentActionsMinusMedium = "contentActions_minus--medium"
    case contentActionsMinusSmall = "contentActions_minus--small"
    case contentActionsPhoneCallMedium = "contentActions_phone-call--medium"
    case contentActionsPhoneCallSmall = "contentActions_phone-call--small"
    case contentActionsPhoneCallTiny = "contentActions_phone-call--tiny"
    case contentActionsPlusMedium = "contentActions_plus--medium"
    case contentActionsPlusSmall = "contentActions_plus--small"
    case contentActionsPreviewMedium = "contentActions_preview--medium"
    case contentActionsPreviewSmall = "contentActions_preview--small"
    case contentActionsPreviewCarouselMedium = "contentActions_preview-carousel--medium"
    case contentActionsPreviewCarouselSmall = "contentActions_preview-carousel--small"
    case contentActionsShareMedium = "contentActions_share--medium"
    case contentActionsShareSmall = "contentActions_share--small"
    case contentActionsShareAltMedium = "contentActions_share-alt--medium"
    case contentActionsShareAltSmall = "contentActions_share-alt--small"
    case contentActionsSortMedium = "contentActions_sort--medium"
    case contentActionsSortSmall = "contentActions_sort--small"
    case contentActionsSubtractMedium = "contentActions_subtract--medium"
    case contentActionsSubtractSmall = "contentActions_subtract--small"
    case contentActionsTrashMedium = "contentActions_trash--medium"
    case contentActionsTrashSmall = "contentActions_trash--small"
    case contentActionsUploadMedium = "contentActions_upload--medium"
    case contentActionsUploadSmall = "contentActions_upload--small"
    case contentActionsVideoMedium = "contentActions_video--medium"
    case contentActionsVideoSmall = "contentActions_video--small"
    case contentActionsVideoTiny = "contentActions_video--tiny"
    case contentModifierAvatarMedium = "contentModifier_avatar--medium"
    case contentModifierAvatarSmall = "contentModifier_avatar--small"
    case contentModifierAwardMedium = "contentModifier_award--medium"
    case contentModifierAwardSmall = "contentModifier_award--small"
    case contentModifierBackgroundCheckMedium = "contentModifier_background-check--medium"
    case contentModifierBackgroundCheckSmall = "contentModifier_background-check--small"
    case contentModifierBarGraphMedium = "contentModifier_bar-graph--medium"
    case contentModifierBarGraphSmall = "contentModifier_bar-graph--small"
    case contentModifierBusinessVerificationMedium = "contentModifier_business-verification--medium"
    case contentModifierBusinessVerificationSmall = "contentModifier_business-verification--small"
    case contentModifierCertifiedMedium = "contentModifier_certified--medium"
    case contentModifierCertifiedSmall = "contentModifier_certified--small"
    case contentModifierChartMedium = "contentModifier_chart--medium"
    case contentModifierChartSmall = "contentModifier_chart--small"
    case contentModifierCircleCheckMedium = "contentModifier_circle-check--medium"
    case contentModifierCircleCheckSmall = "contentModifier_circle-check--small"
    case contentModifierCircleCheckFilledMedium = "contentModifier_circle-check-filled--medium"
    case contentModifierCircleCheckFilledSmall = "contentModifier_circle-check-filled--small"
    case contentModifierCircleMapPinFilledMedium = "contentModifier_circle-map-pin-filled--medium"
    case contentModifierCircleMapPinFilledSmall = "contentModifier_circle-map-pin-filled--small"
    case contentModifierCircleMapPinFilledTiny = "contentModifier_circle-map-pin-filled--tiny"
    case contentModifierCircleMoneyFilledMedium = "contentModifier_circle-money-filled--medium"
    case contentModifierCircleMoneyFilledSmall = "contentModifier_circle-money-filled--small"
    case contentModifierCircleMoneyFilledTiny = "contentModifier_circle-money-filled--tiny"
    case contentModifierCreditCardMedium = "contentModifier_credit-card--medium"
    case contentModifierCreditCardSmall = "contentModifier_credit-card--small"
    case contentModifierDataMedium = "contentModifier_data--medium"
    case contentModifierDataSmall = "contentModifier_data--small"
    case contentModifierDataTiny = "contentModifier_data--tiny"
    case contentModifierDatePlaceholderMedium = "contentModifier_date-placeholder--medium"
    case contentModifierDatePlaceholderSmall = "contentModifier_date-placeholder--small"
    case contentModifierDatePlaceholderTiny = "contentModifier_date-placeholder--tiny"
    case contentModifierDateTimeMedium = "contentModifier_date-time--medium"
    case contentModifierDateTimeSmall = "contentModifier_date-time--small"
    case contentModifierDateTimeTiny = "contentModifier_date-time--tiny"
    case contentModifierDateTimeFilledMedium = "contentModifier_date-time-filled--medium"
    case contentModifierDateTimeFilledSmall = "contentModifier_date-time-filled--small"
    case contentModifierDateTimeFilledTiny = "contentModifier_date-time-filled--tiny"
    case contentModifierDocumentMedium = "contentModifier_document--medium"
    case contentModifierDocumentSmall = "contentModifier_document--small"
    case contentModifierDraftsMedium = "contentModifier_drafts--medium"
    case contentModifierDraftsSmall = "contentModifier_drafts--small"
    case contentModifierEnergyMedium = "contentModifier_energy--medium"
    case contentModifierEnergySmall = "contentModifier_energy--small"
    case contentModifierFireMedium = "contentModifier_fire--medium"
    case contentModifierGiftMedium = "contentModifier_gift--medium"
    case contentModifierGiftSmall = "contentModifier_gift--small"
    case contentModifierGiftTiny = "contentModifier_gift--tiny"
    case contentModifierHeartRateMedium = "contentModifier_heart-rate--medium"
    case contentModifierLightbulbMedium = "contentModifier_lightbulb--medium"
    case contentModifierLightbulbSmall = "contentModifier_lightbulb--small"
    case contentModifierLightbulbTiny = "contentModifier_lightbulb--tiny"
    case contentModifierLightningMedium = "contentModifier_lightning--medium"
    case contentModifierLightningSmall = "contentModifier_lightning--small"
    case contentModifierLightningTiny = "contentModifier_lightning--tiny"
    case contentModifierListMedium = "contentModifier_list--medium"
    case contentModifierListSmall = "contentModifier_list--small"
    case contentModifierListTiny = "contentModifier_list--tiny"
    case contentModifierLocationMedium = "contentModifier_location--medium"
    case contentModifierLocationSmall = "contentModifier_location--small"
    case contentModifierLockedMedium = "contentModifier_locked--medium"
    case contentModifierLockedSmall = "contentModifier_locked--small"
    case contentModifierLockedTiny = "contentModifier_locked--tiny"
    case contentModifierMapMedium = "contentModifier_map--medium"
    case contentModifierMapSmall = "contentModifier_map--small"
    case contentModifierMapPinMedium = "contentModifier_map-pin--medium"
    case contentModifierMapPinSmall = "contentModifier_map-pin--small"
    case contentModifierMapPinTiny = "contentModifier_map-pin--tiny"
    case contentModifierMeetingConfirmedMedium = "contentModifier_meeting-confirmed--medium"
    case contentModifierMeetingConfirmedSmall = "contentModifier_meeting-confirmed--small"
    case contentModifierMeetingConfirmedTiny = "contentModifier_meeting-confirmed--tiny"
    case contentModifierMeetingDeclinedMedium = "contentModifier_meeting-declined--medium"
    case contentModifierMeetingDeclinedSmall = "contentModifier_meeting-declined--small"
    case contentModifierMessageMedium = "contentModifier_message--medium"
    case contentModifierMessageSmall = "contentModifier_message--small"
    case contentModifierMessageTiny = "contentModifier_message--tiny"
    case contentModifierMessageDeclinedMedium = "contentModifier_message-declined--medium"
    case contentModifierMessageDeclinedSmall = "contentModifier_message-declined--small"
    case contentModifierMoldMedium = "contentModifier_mold--medium"
    case contentModifierMoldSmall = "contentModifier_mold--small"
    case contentModifierMoldTiny = "contentModifier_mold--tiny"
    case contentModifierMoneyMedium = "contentModifier_money--medium"
    case contentModifierMoneySmall = "contentModifier_money--small"
    case contentModifierMoneyTiny = "contentModifier_money--tiny"
    case contentModifierPeopleMedium = "contentModifier_people--medium"
    case contentModifierPeopleSmall = "contentModifier_people--small"
    case contentModifierPriceAssuranceTiny = "contentModifier_price-assurance--tiny"
    case contentModifierPriceTagMedium = "contentModifier_price-tag--medium"
    case contentModifierPriceTagSmall = "contentModifier_price-tag--small"
    case contentModifierPriceTagTiny = "contentModifier_price-tag--tiny"
    case contentModifierPriceTagFilledSmall = "contentModifier_price-tag-filled--small"
    case contentModifierRefundMedium = "contentModifier_refund--medium"
    case contentModifierRefundSmall = "contentModifier_refund--small"
    case contentModifierScheduleMeetingMedium = "contentModifier_schedule-meeting--medium"
    case contentModifierScheduleMeetingSmall = "contentModifier_schedule-meeting--small"
    case contentModifierSecurityMedium = "contentModifier_security--medium"
    case contentModifierSecuritySmall = "contentModifier_security--small"
    case contentModifierSecurityTiny = "contentModifier_security--tiny"
    case contentModifierSentMedium = "contentModifier_sent--medium"
    case contentModifierSentSmall = "contentModifier_sent--small"
    case contentModifierSentFilledSmall = "contentModifier_sent-filled--small"
    case contentModifierServicesMedium = "contentModifier_services--medium"
    case contentModifierServicesSmall = "contentModifier_services--small"
    case contentModifierServicesFilledMedium = "contentModifier_services-filled--medium"
    case contentModifierTimeMedium = "contentModifier_time--medium"
    case contentModifierTimeSmall = "contentModifier_time--small"
    case contentModifierTimeTiny = "contentModifier_time--tiny"
    case contentModifierTrophyMedium = "contentModifier_trophy--medium"
    case contentModifierTrophySmall = "contentModifier_trophy--small"
    case contentModifierTrophyTiny = "contentModifier_trophy--tiny"
    case contentModifierUserMedium = "contentModifier_user--medium"
    case contentModifierUserSmall = "contentModifier_user--small"
    case contentModifierViewedMedium = "contentModifier_viewed--medium"
    case contentModifierViewedSmall = "contentModifier_viewed--small"
    case contentModifierWaterDropsMedium = "contentModifier_water-drops--medium"
    case contentModifierWaterDropsSmall = "contentModifier_water-drops--small"
    case contentModifierWavesMedium = "contentModifier_waves--medium"
    case contentModifierWavesSmall = "contentModifier_waves--small"
    case contentModifierWavesTiny = "contentModifier_waves--tiny"
    case contentModifierWebsiteMedium = "contentModifier_website--medium"
    case contentModifierWebsiteSmall = "contentModifier_website--small"
    case creditCardAmericanExpressMedium = "creditCard_american-express--medium"
    case creditCardDiscoverCardMedium = "creditCard_discover-card--medium"
    case creditCardMastercardMedium = "creditCard_mastercard--medium"
    case creditCardVisaMedium = "creditCard_visa--medium"
    case featureBookmarkMedium = "feature_bookmark--medium"
    case featureBookmarkSmall = "feature_bookmark--small"
    case featureCameraMedium = "feature_camera--medium"
    case featureCameraSmall = "feature_camera--small"
    case featureChatMedium = "feature_chat--medium"
    case featureChatSmall = "feature_chat--small"
    case featureExploreMedium = "feature_explore--medium"
    case featureExploreSmall = "feature_explore--small"
    case featureExploreFilledMedium = "feature_explore-filled--medium"
    case featureInboxMedium = "feature_inbox--medium"
    case featureInboxSmall = "feature_inbox--small"
    case featureInboxFilledMedium = "feature_inbox-filled--medium"
    case featureInboxFilledSmall = "feature_inbox-filled--small"
    case featureMailMedium = "feature_mail--medium"
    case featureMailSmall = "feature_mail--small"
    case featureMailFilledMedium = "feature_mail-filled--medium"
    case featureMailFilledSmall = "feature_mail-filled--small"
    case featureMessagesMedium = "feature_messages--medium"
    case featureMessagesSmall = "feature_messages--small"
    case featureMessagesFilledMedium = "feature_messages-filled--medium"
    case featureMessagesFilledSmall = "feature_messages-filled--small"
    case featurePortraitMedium = "feature_portrait--medium"
    case featurePortraitSmall = "feature_portrait--small"
    case featurePortraitFilledMedium = "feature_portrait-filled--medium"
    case featurePortraitFilledSmall = "feature_portrait-filled--small"
    case featurePreferencesMedium = "feature_preferences--medium"
    case featurePreferencesSmall = "feature_preferences--small"
    case featurePromotedMedium = "feature_promoted--medium"
    case featurePromotedSmall = "feature_promoted--small"
    case featurePromotedTiny = "feature_promoted--tiny"
    case featureStoreMedium = "feature_store--medium"
    case featureStoreSmall = "feature_store--small"
    case featureStoreFilledMedium = "feature_store-filled--medium"
    case featureStoreFilledSmall = "feature_store-filled--small"
    case inputsFavoriteMedium = "inputs_favorite--medium"
    case inputsFavoriteSmall = "inputs_favorite--small"
    case inputsFavoriteTiny = "inputs_favorite--tiny"
    case inputsFavoriteFilledMedium = "inputs_favorite-filled--medium"
    case inputsFavoriteFilledSmall = "inputs_favorite-filled--small"
    case inputsFavoriteFilledTiny = "inputs_favorite-filled--tiny"
    case inputsStarMedium = "inputs_star--medium"
    case inputsStarSmall = "inputs_star--small"
    case inputsStarTiny = "inputs_star--tiny"
    case inputsStarFilledMedium = "inputs_star-filled--medium"
    case inputsStarFilledSmall = "inputs_star-filled--small"
    case inputsStarFilledTiny = "inputs_star-filled--tiny"
    case inputsStarHalfFilledMedium = "inputs_star-half-filled--medium"
    case inputsStarHalfFilledSmall = "inputs_star-half-filled--small"
    case inputsStarHalfFilledTiny = "inputs_star-half-filled--tiny"
    case inputsThumbsDownMedium = "inputs_thumbs-down--medium"
    case inputsThumbsDownSmall = "inputs_thumbs-down--small"
    case inputsThumbsDownTiny = "inputs_thumbs-down--tiny"
    case inputsThumbsDownFilledMedium = "inputs_thumbs-down-filled--medium"
    case inputsThumbsDownFilledSmall = "inputs_thumbs-down-filled--small"
    case inputsThumbsDownFilledTiny = "inputs_thumbs-down-filled--tiny"
    case inputsThumbsUpMedium = "inputs_thumbs-up--medium"
    case inputsThumbsUpSmall = "inputs_thumbs-up--small"
    case inputsThumbsUpTiny = "inputs_thumbs-up--tiny"
    case inputsThumbsUpFilledMedium = "inputs_thumbs-up-filled--medium"
    case inputsThumbsUpFilledSmall = "inputs_thumbs-up-filled--small"
    case inputsThumbsUpFilledTiny = "inputs_thumbs-up-filled--tiny"
    case metaCategoryBusinessMedium = "metaCategory_business--medium"
    case metaCategoryBusinessSmall = "metaCategory_business--small"
    case metaCategoryBusinessTiny = "metaCategory_business--tiny"
    case metaCategoryCraftsMedium = "metaCategory_crafts--medium"
    case metaCategoryCraftsSmall = "metaCategory_crafts--small"
    case metaCategoryDesignWebMedium = "metaCategory_design-web--medium"
    case metaCategoryDesignWebSmall = "metaCategory_design-web--small"
    case metaCategoryEventsMedium = "metaCategory_events--medium"
    case metaCategoryEventsSmall = "metaCategory_events--small"
    case metaCategoryEventsTiny = "metaCategory_events--tiny"
    case metaCategoryFallMedium = "metaCategory_fall--medium"
    case metaCategoryFallSmall = "metaCategory_fall--small"
    case metaCategoryFallTiny = "metaCategory_fall--tiny"
    case metaCategoryHomeMedium = "metaCategory_home--medium"
    case metaCategoryHomeSmall = "metaCategory_home--small"
    case metaCategoryHomeTiny = "metaCategory_home--tiny"
    case metaCategoryLegalMedium = "metaCategory_legal--medium"
    case metaCategoryLegalSmall = "metaCategory_legal--small"
    case metaCategoryLessonsMedium = "metaCategory_lessons--medium"
    case metaCategoryLessonsSmall = "metaCategory_lessons--small"
    case metaCategoryPersonalMedium = "metaCategory_personal--medium"
    case metaCategoryPersonalSmall = "metaCategory_personal--small"
    case metaCategoryPetsMedium = "metaCategory_pets--medium"
    case metaCategoryPetsSmall = "metaCategory_pets--small"
    case metaCategoryPetsTiny = "metaCategory_pets--tiny"
    case metaCategoryPhotographyMedium = "metaCategory_photography--medium"
    case metaCategoryPhotographySmall = "metaCategory_photography--small"
    case metaCategoryRepairSupportMedium = "metaCategory_repair-support--medium"
    case metaCategoryRepairSupportSmall = "metaCategory_repair-support--small"
    case metaCategoryRepairSupportTiny = "metaCategory_repair-support--tiny"
    case metaCategorySpringMedium = "metaCategory_spring--medium"
    case metaCategorySpringSmall = "metaCategory_spring--small"
    case metaCategorySpringTiny = "metaCategory_spring--tiny"
    case metaCategorySummerMedium = "metaCategory_summer--medium"
    case metaCategorySummerSmall = "metaCategory_summer--small"
    case metaCategorySummerTiny = "metaCategory_summer--tiny"
    case metaCategoryWeddingMedium = "metaCategory_wedding--medium"
    case metaCategoryWeddingSmall = "metaCategory_wedding--small"
    case metaCategoryWellnessMedium = "metaCategory_wellness--medium"
    case metaCategoryWellnessSmall = "metaCategory_wellness--small"
    case metaCategoryWellnessTiny = "metaCategory_wellness--tiny"
    case metaCategoryWinterMedium = "metaCategory_winter--medium"
    case metaCategoryWinterSmall = "metaCategory_winter--small"
    case metaCategoryWinterTiny = "metaCategory_winter--tiny"
    case metaCategoryWritingTranslationMedium = "metaCategory_writing-translation--medium"
    case metaCategoryWritingTranslationSmall = "metaCategory_writing-translation--small"
    case navigationArrowDownMedium = "navigation_arrow-down--medium"
    case navigationArrowDownSmall = "navigation_arrow-down--small"
    case navigationArrowDownTiny = "navigation_arrow-down--tiny"
    case navigationArrowLeftMedium = "navigation_arrow-left--medium"
    case navigationArrowLeftSmall = "navigation_arrow-left--small"
    case navigationArrowLeftTiny = "navigation_arrow-left--tiny"
    case navigationArrowRightMedium = "navigation_arrow-right--medium"
    case navigationArrowRightSmall = "navigation_arrow-right--small"
    case navigationArrowRightTiny = "navigation_arrow-right--tiny"
    case navigationArrowUpMedium = "navigation_arrow-up--medium"
    case navigationArrowUpSmall = "navigation_arrow-up--small"
    case navigationArrowUpTiny = "navigation_arrow-up--tiny"
    case navigationCaretDownMedium = "navigation_caret-down--medium"
    case navigationCaretDownSmall = "navigation_caret-down--small"
    case navigationCaretDownTiny = "navigation_caret-down--tiny"
    case navigationCaretLeftMedium = "navigation_caret-left--medium"
    case navigationCaretLeftSmall = "navigation_caret-left--small"
    case navigationCaretLeftTiny = "navigation_caret-left--tiny"
    case navigationCaretRightMedium = "navigation_caret-right--medium"
    case navigationCaretRightSmall = "navigation_caret-right--small"
    case navigationCaretRightTiny = "navigation_caret-right--tiny"
    case navigationCaretUpMedium = "navigation_caret-up--medium"
    case navigationCaretUpSmall = "navigation_caret-up--small"
    case navigationCaretUpTiny = "navigation_caret-up--tiny"
    case navigationCloseMedium = "navigation_close--medium"
    case navigationCloseSmall = "navigation_close--small"
    case navigationCloseTiny = "navigation_close--tiny"
    case navigationExpandMedium = "navigation_expand--medium"
    case navigationExpandSmall = "navigation_expand--small"
    case navigationFullscreenMedium = "navigation_fullscreen--medium"
    case navigationFullscreenSmall = "navigation_fullscreen--small"
    case navigationFullscreenCollapseMedium = "navigation_fullscreen-collapse--medium"
    case navigationFullscreenCollapseSmall = "navigation_fullscreen-collapse--small"
    case navigationHamburgerMedium = "navigation_hamburger--medium"
    case navigationHamburgerSmall = "navigation_hamburger--small"
    case navigationHomeMedium = "navigation_home--medium"
    case navigationHomeSmall = "navigation_home--small"
    case navigationMoreHorizontalMedium = "navigation_more-horizontal--medium"
    case navigationMoreHorizontalSmall = "navigation_more-horizontal--small"
    case navigationMoreVerticalMedium = "navigation_more-vertical--medium"
    case navigationMoreVerticalSmall = "navigation_more-vertical--small"
    case navigationPlayMedium = "navigation_play--medium"
    case navigationPlaySmall = "navigation_play--small"
    case navigationRefreshMedium = "navigation_refresh--medium"
    case navigationRefreshSmall = "navigation_refresh--small"
    case navigationReplyTiny = "navigation_reply--tiny"
    case navigationSearchMedium = "navigation_search--medium"
    case navigationSearchSmall = "navigation_search--small"
    case navigationSearchTiny = "navigation_search--tiny"
    case navigationSettingsMedium = "navigation_settings--medium"
    case navigationSettingsSmall = "navigation_settings--small"
    case navigationShrinkMedium = "navigation_shrink--medium"
    case navigationShrinkSmall = "navigation_shrink--small"
    case navigationSyncSmall = "navigation_sync--small"
    case navigationSyncTiny = "navigation_sync--tiny"
    case notificationAlertsBlockedMedium = "notificationAlerts_blocked--medium"
    case notificationAlertsBlockedSmall = "notificationAlerts_blocked--small"
    case notificationAlertsBlockedFilledMedium = "notificationAlerts_blocked-filled--medium"
    case notificationAlertsBlockedFilledSmall = "notificationAlerts_blocked-filled--small"
    case notificationAlertsExclamationMedium = "notificationAlerts_exclamation--medium"
    case notificationAlertsExclamationSmall = "notificationAlerts_exclamation--small"
    case notificationAlertsHelpMedium = "notificationAlerts_help--medium"
    case notificationAlertsHelpSmall = "notificationAlerts_help--small"
    case notificationAlertsInfoMedium = "notificationAlerts_info--medium"
    case notificationAlertsInfoSmall = "notificationAlerts_info--small"
    case notificationAlertsInfoTiny = "notificationAlerts_info--tiny"
    case notificationAlertsInfoFilledMedium = "notificationAlerts_info-filled--medium"
    case notificationAlertsInfoFilledSmall = "notificationAlerts_info-filled--small"
    case notificationAlertsNotificationMedium = "notificationAlerts_notification--medium"
    case notificationAlertsNotificationSmall = "notificationAlerts_notification--small"
    case notificationAlertsNotificationTiny = "notificationAlerts_notification--tiny"
    case notificationAlertsNotificationFilledMedium = "notificationAlerts_notification-filled--medium"
    case notificationAlertsWarningMedium = "notificationAlerts_warning--medium"
    case notificationAlertsWarningSmall = "notificationAlerts_warning--small"
    case notificationAlertsWarningFilledMedium = "notificationAlerts_warning-filled--medium"
    case notificationAlertsWarningFilledSmall = "notificationAlerts_warning-filled--small"
    case socialAppleLoginMedium = "social_apple-login--medium"
    case socialFacebookMedium = "social_facebook--medium"
    case socialFacebookSmall = "social_facebook--small"
    case socialFacebookLoginMedium = "social_facebook-login--medium"
    case socialGoSiteMedium = "social_go-site--medium"
    case socialGoSiteSmall = "social_go-site--small"
    case socialGoSiteTiny = "social_go-site--tiny"
    case socialGoogleLoginMedium = "social_google-login--medium"
    case socialGoogleLoginSmall = "social_google-login--small"
    case socialGooglePlusMedium = "social_google-plus--medium"
    case socialGooglePlusSmall = "social_google-plus--small"
    case socialHousecallProMedium = "social_housecall-pro--medium"
    case socialHousecallProSmall = "social_housecall-pro--small"
    case socialHousecallProTiny = "social_housecall-pro--tiny"
    case socialInstagramMedium = "social_instagram--medium"
    case socialInstagramSmall = "social_instagram--small"
    case socialMessengerMedium = "social_messenger--medium"
    case socialMessengerSmall = "social_messenger--small"
    case socialPinterestMedium = "social_pinterest--medium"
    case socialPinterestSmall = "social_pinterest--small"
    case socialServiceTitanMedium = "social_service-titan--medium"
    case socialServiceTitanSmall = "social_service-titan--small"
    case socialServiceTitanTiny = "social_service-titan--tiny"
    case socialTwitterMedium = "social_twitter--medium"
    case socialTwitterSmall = "social_twitter--small"
    case socialVenmoMedium = "social_venmo--medium"
    case socialVenmoSmall = "social_venmo--small"
    case socialVenmoTiny = "social_venmo--tiny"
    case socialJobberMedium = "social_jobber--medium"
    case socialJobberSmall = "social_jobber--small"
    case socialJobberTiny = "social_jobber--tiny"
    case socialWorkizMedium = "social_workiz-circle--medium"
    case socialWorkizSmall = "social_workiz-circle--small"
    case socialWorkizTiny = "social_workiz-circle--tiny"

    public var image: UIImage {
        guard let icon = UIImage(named: rawValue, in: Self.bundle, compatibleWith: nil) else {
            assertionFailure("Expected bundle at path \(Self.bundle.bundlePath) to contain icon with name \(rawValue).")
            return UIImage()
        }

        return icon
    }

    /// Dynamically get icon with the specified name (and size), if exists.
    ///
    /// Use of this function is typically discouraged since it creates a dependency
    /// on the file names used for icons that is not caught by the type checker.
    public static func icon(named name: String, size: Size? = nil) -> UIImage? {
        guard let size else {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }

        let regex = ".*(\(Size.allCases.map(\.rawValue).joined(separator: "|")))$"
        guard !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: name) else {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }

        return UIImage(named: "\(name)\(size.rawValue)", in: bundle, compatibleWith: nil)
    }

    // MARK: - Private
    private static var bundle: Bundle = .module
}
