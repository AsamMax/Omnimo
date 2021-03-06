; =================================================
; @Include template file to populate all
; Next 36-Hour Weather information from Weather.com
;==================================================

; Uncomment this measure if you are not including 
; WeatherCurrent.inc in your skin.

;[@CurrentAll]
;Measure=WebParser
;Group=Weather | WeatherCurrent
;Url=#URLcurrent#
;RegExp=(?siU)^(.*)$
;UpdateRate=#UpdateRate#

; Parent for "Next 36 Hours".

; These are the "cards" displayed in a set of 5.
; What days and times of day displayed will vary depending on
; the current time of day.

[@36HoursParent]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@CurrentAll]
StringIndex=0
RegExp=#36HourCards#
LogSubstringErrors=0

[@Card1Day]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=1

[@Card1Conditions]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=2
DecodeCharacterReference=1

[@Card1Icon]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=3

[@Card1HighLowText]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=4

[@Card1HighLowValue]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=5

[@Card1HighLowSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=6

[@Card1Precipitation]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=7

[@Card1PrecipitationSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=8

[@Card2Day]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=9

[@Card2Conditions]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=10
DecodeCharacterReference=1

[@Card2Icon]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=11

[@Card2HighLowText]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=12

[@Card2HighLowValue]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=13

[@Card2HighLowSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=14

[@Card2Precipitation]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=15

[@Card2PrecipitationSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=16

[@Card3Day]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=17

[@Card3Conditions]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=18
DecodeCharacterReference=1

[@Card3Icon]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=19

[@Card3HighLowText]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=20

[@Card3HighLowValue]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=21

[@Card3HighLowSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=22

[@Card3Precipitation]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=23

[@Card3PrecipitationSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=24

[@Card4Day]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=25

[@Card4Conditions]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=26
DecodeCharacterReference=1

[@Card4Icon]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=27

[@Card4HighLowText]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=28

[@Card4HighLowValue]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=29

[@Card4HighLowSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=30

[@Card4Precipitation]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=31

[@Card4PrecipitationSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=32

[@Card5Day]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=33

[@Card5Conditions]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=34
DecodeCharacterReference=1

[@Card5Icon]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=35

[@Card5HighLowText]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=36

[@Card5HighLowValue]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=37

[@Card5HighLowSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=38

[@Card5Precipitation]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=39

[@Card5PrecipitationSymbol]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursParent]
StringIndex=40

; Parent for "Next 36 Hours" Details Text.
; These are the "cards" displayed in a set of 5.

[@36HoursDetailsParent]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@CurrentAll]
StringIndex=0
RegExp=#Details36Hours#
LogSubstringErrors=0

; Children for the "Next 36 Hours" Details Text.
; Odd-numbered StringIndexes are just repeats of the 
; Name of the day. Just use those if needed

[@Card1Details]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursDetailsParent]
StringIndex=2
DecodeCharacterReference=1

[@Card2Details]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursDetailsParent]
StringIndex=4
DecodeCharacterReference=1

[@Card3Details]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursDetailsParent]
StringIndex=6
DecodeCharacterReference=1

[@Card4Details]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursDetailsParent]
StringIndex=8
DecodeCharacterReference=1

[@Card5Details]
Measure=WebParser
Group=Weather | WeatherNext36Hours
Url=[@36HoursDetailsParent]
StringIndex=10
DecodeCharacterReference=1
