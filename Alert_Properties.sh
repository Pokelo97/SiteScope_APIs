#!/bin/bash

entityID=$1
MAIL_NAME=$2
mail=$3
email_Properties='{
                    "properties": {
                            "isOldAlertType": "false",
                            "etiType": "",
                            "objalertcategoryvalues": null,
                            "reportEvents": "false",
                            "useMonitorEventMapping": "false",
                            "_compliantTemplateID": "",
                            "eventPreferenceId": "CommonEventInstancePreferences_alertDefault",
                            "alertSchedule": null,
                            "objalertcategory": [],
                            "objcategorynames": null,
                            "objcategoryvalues": null,
                            "pname": "'$MAIL_NAME'",
                            "objalertcategorynames": null,
                            "objcategory": [],
                            "objectDependencyTree": [
                                "'$entityID'"
                            ],
                            "disableScheduleStartTimeSeconds": 0,
                            "isAnalyticsAlert": false,
                            "alertDisable": "None",
                            "etiValue": "",
                            "disableScheduleEndTimeSeconds": 0,
                            "classMatchString": [],
                            "alertDisableDescription": ""
                        },
                        "alertActionList": [
                            {
                                "actionProperties": {
                                    "template": "'$MAIL_NAME'",
                                    "categoryString": "category",
                                    "subject": "'$MAIL_NAME'",
                                    "previousCategory": "",
                                    "escalateActionId": null,
                                    "when": "always",
                                    "_compliantTemplateID": "",
                                    "maxGroupCount": "1",
                                    "toOther": "'$mail'",
                                    "usePreviousCategoryCount": "false",
                                    "alertType": "Mailto",
                                    "multiRepetCount": "1",
                                    "escalateActionCount": "2",
                                    "schedule": "",
                                    "previousCategoryCount": "2",
                                    "alwaysCount": "1",
                                    "onceCount": "1",
                                    "multiStartCount": "1",
                                    "to": [],
                                    "category": "error",
                                    "useAsClosingAction": "false",
                                    "actionName": "Warning_Email"
                                }
                            }
                        ]
                }'
echo "$email_Properties" | /usr/bin/jq > email_Properties.json