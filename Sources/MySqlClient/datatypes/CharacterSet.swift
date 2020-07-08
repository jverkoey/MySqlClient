// Copyright 2019-present the MySqlClient authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import BinaryCodable
import Foundation

/**
 A MySql character set identifier.

 Documentation: https://dev.mysql.com/doc/internals/en/character-set.html#packet-Protocol::CharacterSet
 Generated from `SELECT collation_name, id FROM information_schema.collations ORDER BY id;`
 */
enum CharacterSet: UInt8, BinaryCodable {
  case big5ChineseCi = 1
  case latin2CzechCs = 2
  case dec8SwedishCi = 3
  case cp850GeneralCi = 4
  case latin1German1Ci = 5
  case hp8EnglishCi = 6
  case koi8RGeneralCi = 7
  case latin1SwedishCi = 8
  case latin2GeneralCi = 9
  case swe7SwedishCi = 10
  case asciiGeneralCi = 11
  case ujisJapaneseCi = 12
  case sjisJapaneseCi = 13
  case cp1251BulgarianCi = 14
  case latin1DanishCi = 15
  case hebrewGeneralCi = 16
  case tis620ThaiCi = 18
  case euckrKoreanCi = 19
  case latin7EstonianCs = 20
  case latin2HungarianCi = 21
  case koi8UGeneralCi = 22
  case cp1251UkrainianCi = 23
  case gb2312ChineseCi = 24
  case greekGeneralCi = 25
  case cp1250GeneralCi = 26
  case latin2CroatianCi = 27
  case gbkChineseCi = 28
  case cp1257LithuanianCi = 29
  case latin5TurkishCi = 30
  case latin1German2Ci = 31
  case armscii8GeneralCi = 32
  case utf8GeneralCi = 33
  case cp1250CzechCs = 34
  case ucs2GeneralCi = 35
  case cp866GeneralCi = 36
  case keybcs2GeneralCi = 37
  case macceGeneralCi = 38
  case macromanGeneralCi = 39
  case cp852GeneralCi = 40
  case latin7GeneralCi = 41
  case latin7GeneralCs = 42
  case macceBin = 43
  case cp1250CroatianCi = 44
  case utf8Mb4GeneralCi = 45
  case utf8Mb4Bin = 46
  case latin1Bin = 47
  case latin1GeneralCi = 48
  case latin1GeneralCs = 49
  case cp1251Bin = 50
  case cp1251GeneralCi = 51
  case cp1251GeneralCs = 52
  case macromanBin = 53
  case utf16GeneralCi = 54
  case utf16Bin = 55
  case utf16LeGeneralCi = 56
  case cp1256GeneralCi = 57
  case cp1257Bin = 58
  case cp1257GeneralCi = 59
  case utf32GeneralCi = 60
  case utf32Bin = 61
  case utf16LeBin = 62
  case binary = 63
  case armscii8Bin = 64
  case asciiBin = 65
  case cp1250Bin = 66
  case cp1256Bin = 67
  case cp866Bin = 68
  case dec8Bin = 69
  case greekBin = 70
  case hebrewBin = 71
  case hp8Bin = 72
  case keybcs2Bin = 73
  case koi8RBin = 74
  case koi8UBin = 75
  case latin2Bin = 77
  case latin5Bin = 78
  case latin7Bin = 79
  case cp850Bin = 80
  case cp852Bin = 81
  case swe7Bin = 82
  case utf8Bin = 83
  case big5Bin = 84
  case euckrBin = 85
  case gb2312Bin = 86
  case gbkBin = 87
  case sjisBin = 88
  case tis620Bin = 89
  case ucs2Bin = 90
  case ujisBin = 91
  case geostd8GeneralCi = 92
  case geostd8Bin = 93
  case latin1SpanishCi = 94
  case cp932JapaneseCi = 95
  case cp932Bin = 96
  case eucjpmsJapaneseCi = 97
  case eucjpmsBin = 98
  case cp1250PolishCi = 99
  case utf16UnicodeCi = 101
  case utf16IcelandicCi = 102
  case utf16LatvianCi = 103
  case utf16RomanianCi = 104
  case utf16SlovenianCi = 105
  case utf16PolishCi = 106
  case utf16EstonianCi = 107
  case utf16SpanishCi = 108
  case utf16SwedishCi = 109
  case utf16TurkishCi = 110
  case utf16CzechCi = 111
  case utf16DanishCi = 112
  case utf16LithuanianCi = 113
  case utf16SlovakCi = 114
  case utf16Spanish2Ci = 115
  case utf16RomanCi = 116
  case utf16PersianCi = 117
  case utf16EsperantoCi = 118
  case utf16HungarianCi = 119
  case utf16SinhalaCi = 120
  case utf16German2Ci = 121
  case utf16CroatianCi = 122
  case utf16Unicode520Ci = 123
  case utf16VietnameseCi = 124
  case ucs2UnicodeCi = 128
  case ucs2IcelandicCi = 129
  case ucs2LatvianCi = 130
  case ucs2RomanianCi = 131
  case ucs2SlovenianCi = 132
  case ucs2PolishCi = 133
  case ucs2EstonianCi = 134
  case ucs2SpanishCi = 135
  case ucs2SwedishCi = 136
  case ucs2TurkishCi = 137
  case ucs2CzechCi = 138
  case ucs2DanishCi = 139
  case ucs2LithuanianCi = 140
  case ucs2SlovakCi = 141
  case ucs2Spanish2Ci = 142
  case ucs2RomanCi = 143
  case ucs2PersianCi = 144
  case ucs2EsperantoCi = 145
  case ucs2HungarianCi = 146
  case ucs2SinhalaCi = 147
  case ucs2German2Ci = 148
  case ucs2CroatianCi = 149
  case ucs2Unicode520Ci = 150
  case ucs2VietnameseCi = 151
  case ucs2GeneralMysql500Ci = 159
  case utf32UnicodeCi = 160
  case utf32IcelandicCi = 161
  case utf32LatvianCi = 162
  case utf32RomanianCi = 163
  case utf32SlovenianCi = 164
  case utf32PolishCi = 165
  case utf32EstonianCi = 166
  case utf32SpanishCi = 167
  case utf32SwedishCi = 168
  case utf32TurkishCi = 169
  case utf32CzechCi = 170
  case utf32DanishCi = 171
  case utf32LithuanianCi = 172
  case utf32SlovakCi = 173
  case utf32Spanish2Ci = 174
  case utf32RomanCi = 175
  case utf32PersianCi = 176
  case utf32EsperantoCi = 177
  case utf32HungarianCi = 178
  case utf32SinhalaCi = 179
  case utf32German2Ci = 180
  case utf32CroatianCi = 181
  case utf32Unicode520Ci = 182
  case utf32VietnameseCi = 183
  case utf8UnicodeCi = 192
  case utf8IcelandicCi = 193
  case utf8LatvianCi = 194
  case utf8RomanianCi = 195
  case utf8SlovenianCi = 196
  case utf8PolishCi = 197
  case utf8EstonianCi = 198
  case utf8SpanishCi = 199
  case utf8SwedishCi = 200
  case utf8TurkishCi = 201
  case utf8CzechCi = 202
  case utf8DanishCi = 203
  case utf8LithuanianCi = 204
  case utf8SlovakCi = 205
  case utf8Spanish2Ci = 206
  case utf8RomanCi = 207
  case utf8PersianCi = 208
  case utf8EsperantoCi = 209
  case utf8HungarianCi = 210
  case utf8SinhalaCi = 211
  case utf8German2Ci = 212
  case utf8CroatianCi = 213
  case utf8Unicode520Ci = 214
  case utf8VietnameseCi = 215
  case utf8GeneralMysql500Ci = 223
  case utf8Mb4UnicodeCi = 224
  case utf8Mb4IcelandicCi = 225
  case utf8Mb4LatvianCi = 226
  case utf8Mb4RomanianCi = 227
  case utf8Mb4SlovenianCi = 228
  case utf8Mb4PolishCi = 229
  case utf8Mb4EstonianCi = 230
  case utf8Mb4SpanishCi = 231
  case utf8Mb4SwedishCi = 232
  case utf8Mb4TurkishCi = 233
  case utf8Mb4CzechCi = 234
  case utf8Mb4DanishCi = 235
  case utf8Mb4LithuanianCi = 236
  case utf8Mb4SlovakCi = 237
  case utf8Mb4Spanish2Ci = 238
  case utf8Mb4RomanCi = 239
  case utf8Mb4PersianCi = 240
  case utf8Mb4EsperantoCi = 241
  case utf8Mb4HungarianCi = 242
  case utf8Mb4SinhalaCi = 243
  case utf8Mb4German2Ci = 244
  case utf8Mb4CroatianCi = 245
  case utf8Mb4Unicode520Ci = 246
  case utf8Mb4VietnameseCi = 247
  case gb18030ChineseCi = 248
  case gb18030Bin = 249
  case gb18030Unicode520Ci = 250
}
