// Copyright 2019-present the MySqlConnector authors. All Rights Reserved.
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
 */
enum CharacterSet: UInt8, BinaryCodable {
  case big5     = 1
  case dec8     = 3
  case cp850    = 4
  case hp8      = 6
  case koi8r    = 7
  case latin1   = 8
  case latin2   = 9
  case swe7     = 10
  case ascii    = 11
  case ujis     = 12
  case sjis     = 13
  case hebrew   = 16
  case tis620   = 18
  case euckr    = 19
  case koi8u    = 22
  case gb2312   = 24
  case greek    = 25
  case cp1250   = 26
  case gbk      = 28
  case latin5   = 30
  case armscii8 = 32
  case utf8     = 33
  case ucs2     = 35
  case cp866    = 36
  case keybcs2  = 37
  case macce    = 38
  case macroman = 39
  case cp852    = 40
  case latin7   = 41
  case cp1251   = 51
  case utf16    = 54
  case utf16le  = 56
  case cp1256   = 57
  case cp1257   = 59
  case utf32    = 60
  case binary   = 63
  case geostd8  = 92
  case cp932    = 95
  case eucjpms  = 97
  case utf8mb4VietnameseCi = 247
  case gb18030  = 248
  case utf8mb4  = 255
}
