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
 Documentation: https://dev.mysql.com/doc/refman/8.0/en/server-error-reference.html
 Generated from: http://mysql.localhost.net.ar/sources/doxygen/mysql-5.1/mysqld__error_8h-source.html
 */
public enum ErrorCode: UInt16, BinaryCodable {
  case ER_HASHCHK = 1000
  case ER_NISAMCHK = 1001
  case ER_NO = 1002
  case ER_YES = 1003
  case ER_CANT_CREATE_FILE = 1004
  case ER_CANT_CREATE_TABLE = 1005
  case ER_CANT_CREATE_DB = 1006
  case ER_DB_CREATE_EXISTS = 1007
  case ER_DB_DROP_EXISTS = 1008
  case ER_DB_DROP_DELETE = 1009
  case ER_DB_DROP_RMDIR = 1010
  case ER_CANT_DELETE_FILE = 1011
  case ER_CANT_FIND_SYSTEM_REC = 1012
  case ER_CANT_GET_STAT = 1013
  case ER_CANT_GET_WD = 1014
  case ER_CANT_LOCK = 1015
  case ER_CANT_OPEN_FILE = 1016
  case ER_FILE_NOT_FOUND = 1017
  case ER_CANT_READ_DIR = 1018
  case ER_CANT_SET_WD = 1019
  case ER_CHECKREAD = 1020
  case ER_DISK_FULL = 1021
  case ER_DUP_KEY = 1022
  case ER_ERROR_ON_CLOSE = 1023
  case ER_ERROR_ON_READ = 1024
  case ER_ERROR_ON_RENAME = 1025
  case ER_ERROR_ON_WRITE = 1026
  case ER_FILE_USED = 1027
  case ER_FILSORT_ABORT = 1028
  case ER_FORM_NOT_FOUND = 1029
  case ER_GET_ERRNO = 1030
  case ER_ILLEGAL_HA = 1031
  case ER_KEY_NOT_FOUND = 1032
  case ER_NOT_FORM_FILE = 1033
  case ER_NOT_KEYFILE = 1034
  case ER_OLD_KEYFILE = 1035
  case ER_OPEN_AS_READONLY = 1036
  case ER_OUTOFMEMORY = 1037
  case ER_OUT_OF_SORTMEMORY = 1038
  case ER_UNEXPECTED_EOF = 1039
  case ER_CON_COUNT_ERROR = 1040
  case ER_OUT_OF_RESOURCES = 1041
  case ER_BAD_HOST_ERROR = 1042
  case ER_HANDSHAKE_ERROR = 1043
  case ER_DBACCESS_DENIED_ERROR = 1044
  case ER_ACCESS_DENIED_ERROR = 1045
  case ER_NO_DB_ERROR = 1046
  case ER_UNKNOWN_COM_ERROR = 1047
  case ER_BAD_NULL_ERROR = 1048
  case ER_BAD_DB_ERROR = 1049
  case ER_TABLE_EXISTS_ERROR = 1050
  case ER_BAD_TABLE_ERROR = 1051
  case ER_NON_UNIQ_ERROR = 1052
  case ER_SERVER_SHUTDOWN = 1053
  case ER_BAD_FIELD_ERROR = 1054
  case ER_WRONG_FIELD_WITH_GROUP = 1055
  case ER_WRONG_GROUP_FIELD = 1056
  case ER_WRONG_SUM_SELECT = 1057
  case ER_WRONG_VALUE_COUNT = 1058
  case ER_TOO_LONG_IDENT = 1059
  case ER_DUP_FIELDNAME = 1060
  case ER_DUP_KEYNAME = 1061
  case ER_DUP_ENTRY = 1062
  case ER_WRONG_FIELD_SPEC = 1063
  case ER_PARSE_ERROR = 1064
  case ER_EMPTY_QUERY = 1065
  case ER_NONUNIQ_TABLE = 1066
  case ER_INVALID_DEFAULT = 1067
  case ER_MULTIPLE_PRI_KEY = 1068
  case ER_TOO_MANY_KEYS = 1069
  case ER_TOO_MANY_KEY_PARTS = 1070
  case ER_TOO_LONG_KEY = 1071
  case ER_KEY_COLUMN_DOES_NOT_EXITS = 1072
  case ER_BLOB_USED_AS_KEY = 1073
  case ER_TOO_BIG_FIELDLENGTH = 1074
  case ER_WRONG_AUTO_KEY = 1075
  case ER_READY = 1076
  case ER_NORMAL_SHUTDOWN = 1077
  case ER_GOT_SIGNAL = 1078
  case ER_SHUTDOWN_COMPLETE = 1079
  case ER_FORCING_CLOSE = 1080
  case ER_IPSOCK_ERROR = 1081
  case ER_NO_SUCH_INDEX = 1082
  case ER_WRONG_FIELD_TERMINATORS = 1083
  case ER_BLOBS_AND_NO_TERMINATED = 1084
  case ER_TEXTFILE_NOT_READABLE = 1085
  case ER_FILE_EXISTS_ERROR = 1086
  case ER_LOAD_INFO = 1087
  case ER_ALTER_INFO = 1088
  case ER_WRONG_SUB_KEY = 1089
  case ER_CANT_REMOVE_ALL_FIELDS = 1090
  case ER_CANT_DROP_FIELD_OR_KEY = 1091
  case ER_INSERT_INFO = 1092
  case ER_UPDATE_TABLE_USED = 1093
  case ER_NO_SUCH_THREAD = 1094
  case ER_KILL_DENIED_ERROR = 1095
  case ER_NO_TABLES_USED = 1096
  case ER_TOO_BIG_SET = 1097
  case ER_NO_UNIQUE_LOGFILE = 1098
  case ER_TABLE_NOT_LOCKED_FOR_WRITE = 1099
  case ER_TABLE_NOT_LOCKED = 1100
  case ER_BLOB_CANT_HAVE_DEFAULT = 1101
  case ER_WRONG_DB_NAME = 1102
  case ER_WRONG_TABLE_NAME = 1103
  case ER_TOO_BIG_SELECT = 1104
  case ER_UNKNOWN_ERROR = 1105
  case ER_UNKNOWN_PROCEDURE = 1106
  case ER_WRONG_PARAMCOUNT_TO_PROCEDURE = 1107
  case ER_WRONG_PARAMETERS_TO_PROCEDURE = 1108
  case ER_UNKNOWN_TABLE = 1109
  case ER_FIELD_SPECIFIED_TWICE = 1110
  case ER_INVALID_GROUP_FUNC_USE = 1111
  case ER_UNSUPPORTED_EXTENSION = 1112
  case ER_TABLE_MUST_HAVE_COLUMNS = 1113
  case ER_RECORD_FILE_FULL = 1114
  case ER_UNKNOWN_CHARACTER_SET = 1115
  case ER_TOO_MANY_TABLES = 1116
  case ER_TOO_MANY_FIELDS = 1117
  case ER_TOO_BIG_ROWSIZE = 1118
  case ER_STACK_OVERRUN = 1119
  case ER_WRONG_OUTER_JOIN = 1120
  case ER_NULL_COLUMN_IN_INDEX = 1121
  case ER_CANT_FIND_UDF = 1122
  case ER_CANT_INITIALIZE_UDF = 1123
  case ER_UDF_NO_PATHS = 1124
  case ER_UDF_EXISTS = 1125
  case ER_CANT_OPEN_LIBRARY = 1126
  case ER_CANT_FIND_DL_ENTRY = 1127
  case ER_FUNCTION_NOT_DEFINED = 1128
  case ER_HOST_IS_BLOCKED = 1129
  case ER_HOST_NOT_PRIVILEGED = 1130
  case ER_PASSWORD_ANONYMOUS_USER = 1131
  case ER_PASSWORD_NOT_ALLOWED = 1132
  case ER_PASSWORD_NO_MATCH = 1133
  case ER_UPDATE_INFO = 1134
  case ER_CANT_CREATE_THREAD = 1135
  case ER_WRONG_VALUE_COUNT_ON_ROW = 1136
  case ER_CANT_REOPEN_TABLE = 1137
  case ER_INVALID_USE_OF_NULL = 1138
  case ER_REGEXP_ERROR = 1139
  case ER_MIX_OF_GROUP_FUNC_AND_FIELDS = 1140
  case ER_NONEXISTING_GRANT = 1141
  case ER_TABLEACCESS_DENIED_ERROR = 1142
  case ER_COLUMNACCESS_DENIED_ERROR = 1143
  case ER_ILLEGAL_GRANT_FOR_TABLE = 1144
  case ER_GRANT_WRONG_HOST_OR_USER = 1145
  case ER_NO_SUCH_TABLE = 1146
  case ER_NONEXISTING_TABLE_GRANT = 1147
  case ER_NOT_ALLOWED_COMMAND = 1148
  case ER_SYNTAX_ERROR = 1149
  case ER_DELAYED_CANT_CHANGE_LOCK = 1150
  case ER_TOO_MANY_DELAYED_THREADS = 1151
  case ER_ABORTING_CONNECTION = 1152
  case ER_NET_PACKET_TOO_LARGE = 1153
  case ER_NET_READ_ERROR_FROM_PIPE = 1154
  case ER_NET_FCNTL_ERROR = 1155
  case ER_NET_PACKETS_OUT_OF_ORDER = 1156
  case ER_NET_UNCOMPRESS_ERROR = 1157
  case ER_NET_READ_ERROR = 1158
  case ER_NET_READ_INTERRUPTED = 1159
  case ER_NET_ERROR_ON_WRITE = 1160
  case ER_NET_WRITE_INTERRUPTED = 1161
  case ER_TOO_LONG_STRING = 1162
  case ER_TABLE_CANT_HANDLE_BLOB = 1163
  case ER_TABLE_CANT_HANDLE_AUTO_INCREMENT = 1164
  case ER_DELAYED_INSERT_TABLE_LOCKED = 1165
  case ER_WRONG_COLUMN_NAME = 1166
  case ER_WRONG_KEY_COLUMN = 1167
  case ER_WRONG_MRG_TABLE = 1168
  case ER_DUP_UNIQUE = 1169
  case ER_BLOB_KEY_WITHOUT_LENGTH = 1170
  case ER_PRIMARY_CANT_HAVE_NULL = 1171
  case ER_TOO_MANY_ROWS = 1172
  case ER_REQUIRES_PRIMARY_KEY = 1173
  case ER_NO_RAID_COMPILED = 1174
  case ER_UPDATE_WITHOUT_KEY_IN_SAFE_MODE = 1175
  case ER_KEY_DOES_NOT_EXITS = 1176
  case ER_CHECK_NO_SUCH_TABLE = 1177
  case ER_CHECK_NOT_IMPLEMENTED = 1178
  case ER_CANT_DO_THIS_DURING_AN_TRANSACTION = 1179
  case ER_ERROR_DURING_COMMIT = 1180
  case ER_ERROR_DURING_ROLLBACK = 1181
  case ER_ERROR_DURING_FLUSH_LOGS = 1182
  case ER_ERROR_DURING_CHECKPOINT = 1183
  case ER_NEW_ABORTING_CONNECTION = 1184
  case ER_DUMP_NOT_IMPLEMENTED = 1185
  case ER_FLUSH_MASTER_BINLOG_CLOSED = 1186
  case ER_INDEX_REBUILD = 1187
  case ER_MASTER = 1188
  case ER_MASTER_NET_READ = 1189
  case ER_MASTER_NET_WRITE = 1190
  case ER_FT_MATCHING_KEY_NOT_FOUND = 1191
  case ER_LOCK_OR_ACTIVE_TRANSACTION = 1192
  case ER_UNKNOWN_SYSTEM_VARIABLE = 1193
  case ER_CRASHED_ON_USAGE = 1194
  case ER_CRASHED_ON_REPAIR = 1195
  case ER_WARNING_NOT_COMPLETE_ROLLBACK = 1196
  case ER_TRANS_CACHE_FULL = 1197
  case ER_SLAVE_MUST_STOP = 1198
  case ER_SLAVE_NOT_RUNNING = 1199
  case ER_BAD_SLAVE = 1200
  case ER_MASTER_INFO = 1201
  case ER_SLAVE_THREAD = 1202
  case ER_TOO_MANY_USER_CONNECTIONS = 1203
  case ER_SET_CONSTANTS_ONLY = 1204
  case ER_LOCK_WAIT_TIMEOUT = 1205
  case ER_LOCK_TABLE_FULL = 1206
  case ER_READ_ONLY_TRANSACTION = 1207
  case ER_DROP_DB_WITH_READ_LOCK = 1208
  case ER_CREATE_DB_WITH_READ_LOCK = 1209
  case ER_WRONG_ARGUMENTS = 1210
  case ER_NO_PERMISSION_TO_CREATE_USER = 1211
  case ER_UNION_TABLES_IN_DIFFERENT_DIR = 1212
  case ER_LOCK_DEADLOCK = 1213
  case ER_TABLE_CANT_HANDLE_FT = 1214
  case ER_CANNOT_ADD_FOREIGN = 1215
  case ER_NO_REFERENCED_ROW = 1216
  case ER_ROW_IS_REFERENCED = 1217
  case ER_CONNECT_TO_MASTER = 1218
  case ER_QUERY_ON_MASTER = 1219
  case ER_ERROR_WHEN_EXECUTING_COMMAND = 1220
  case ER_WRONG_USAGE = 1221
  case ER_WRONG_NUMBER_OF_COLUMNS_IN_SELECT = 1222
  case ER_CANT_UPDATE_WITH_READLOCK = 1223
  case ER_MIXING_NOT_ALLOWED = 1224
  case ER_DUP_ARGUMENT = 1225
  case ER_USER_LIMIT_REACHED = 1226
  case ER_SPECIFIC_ACCESS_DENIED_ERROR = 1227
  case ER_LOCAL_VARIABLE = 1228
  case ER_GLOBAL_VARIABLE = 1229
  case ER_NO_DEFAULT = 1230
  case ER_WRONG_VALUE_FOR_VAR = 1231
  case ER_WRONG_TYPE_FOR_VAR = 1232
  case ER_VAR_CANT_BE_READ = 1233
  case ER_CANT_USE_OPTION_HERE = 1234
  case ER_NOT_SUPPORTED_YET = 1235
  case ER_MASTER_FATAL_ERROR_READING_BINLOG = 1236
  case ER_SLAVE_IGNORED_TABLE = 1237
  case ER_INCORRECT_GLOBAL_LOCAL_VAR = 1238
  case ER_WRONG_FK_DEF = 1239
  case ER_KEY_REF_DO_NOT_MATCH_TABLE_REF = 1240
  case ER_OPERAND_COLUMNS = 1241
  case ER_SUBQUERY_NO_1_ROW = 1242
  case ER_UNKNOWN_STMT_HANDLER = 1243
  case ER_CORRUPT_HELP_DB = 1244
  case ER_CYCLIC_REFERENCE = 1245
  case ER_AUTO_CONVERT = 1246
  case ER_ILLEGAL_REFERENCE = 1247
  case ER_DERIVED_MUST_HAVE_ALIAS = 1248
  case ER_SELECT_REDUCED = 1249
  case ER_TABLENAME_NOT_ALLOWED_HERE = 1250
  case ER_NOT_SUPPORTED_AUTH_MODE = 1251
  case ER_SPATIAL_CANT_HAVE_NULL = 1252
  case ER_COLLATION_CHARSET_MISMATCH = 1253
  case ER_SLAVE_WAS_RUNNING = 1254
  case ER_SLAVE_WAS_NOT_RUNNING = 1255
  case ER_TOO_BIG_FOR_UNCOMPRESS = 1256
  case ER_ZLIB_Z_MEM_ERROR = 1257
  case ER_ZLIB_Z_BUF_ERROR = 1258
  case ER_ZLIB_Z_DATA_ERROR = 1259
  case ER_CUT_VALUE_GROUP_CONCAT = 1260
  case ER_WARN_TOO_FEW_RECORDS = 1261
  case ER_WARN_TOO_MANY_RECORDS = 1262
  case ER_WARN_NULL_TO_NOTNULL = 1263
  case ER_WARN_DATA_OUT_OF_RANGE = 1264
  case WARN_DATA_TRUNCATED = 1265
  case ER_WARN_USING_OTHER_HANDLER = 1266
  case ER_CANT_AGGREGATE_2COLLATIONS = 1267
  case ER_DROP_USER = 1268
  case ER_REVOKE_GRANTS = 1269
  case ER_CANT_AGGREGATE_3COLLATIONS = 1270
  case ER_CANT_AGGREGATE_NCOLLATIONS = 1271
  case ER_VARIABLE_IS_NOT_STRUCT = 1272
  case ER_UNKNOWN_COLLATION = 1273
  case ER_SLAVE_IGNORED_SSL_PARAMS = 1274
  case ER_SERVER_IS_IN_SECURE_AUTH_MODE = 1275
  case ER_WARN_FIELD_RESOLVED = 1276
  case ER_BAD_SLAVE_UNTIL_COND = 1277
  case ER_MISSING_SKIP_SLAVE = 1278
  case ER_UNTIL_COND_IGNORED = 1279
  case ER_WRONG_NAME_FOR_INDEX = 1280
  case ER_WRONG_NAME_FOR_CATALOG = 1281
  case ER_WARN_QC_RESIZE = 1282
  case ER_BAD_FT_COLUMN = 1283
  case ER_UNKNOWN_KEY_CACHE = 1284
  case ER_WARN_HOSTNAME_WONT_WORK = 1285
  case ER_UNKNOWN_STORAGE_ENGINE = 1286
  case ER_UNUSED_1 = 1287
  case ER_NON_UPDATABLE_TABLE = 1288
  case ER_FEATURE_DISABLED = 1289
  case ER_OPTION_PREVENTS_STATEMENT = 1290
  case ER_DUPLICATED_VALUE_IN_TYPE = 1291
  case ER_TRUNCATED_WRONG_VALUE = 1292
  case ER_TOO_MUCH_AUTO_TIMESTAMP_COLS = 1293
  case ER_INVALID_ON_UPDATE = 1294
  case ER_UNSUPPORTED_PS = 1295
  case ER_GET_ERRMSG = 1296
  case ER_GET_TEMPORARY_ERRMSG = 1297
  case ER_UNKNOWN_TIME_ZONE = 1298
  case ER_WARN_INVALID_TIMESTAMP = 1299
  case ER_INVALID_CHARACTER_STRING = 1300
  case ER_WARN_ALLOWED_PACKET_OVERFLOWED = 1301
  case ER_CONFLICTING_DECLARATIONS = 1302
  case ER_SP_NO_RECURSIVE_CREATE = 1303
  case ER_SP_ALREADY_EXISTS = 1304
  case ER_SP_DOES_NOT_EXIST = 1305
  case ER_SP_DROP_FAILED = 1306
  case ER_SP_STORE_FAILED = 1307
  case ER_SP_LILABEL_MISMATCH = 1308
  case ER_SP_LABEL_REDEFINE = 1309
  case ER_SP_LABEL_MISMATCH = 1310
  case ER_SP_UNINIT_VAR = 1311
  case ER_SP_BADSELECT = 1312
  case ER_SP_BADRETURN = 1313
  case ER_SP_BADSTATEMENT = 1314
  case ER_UPDATE_LOG_DEPRECATED_IGNORED = 1315
  case ER_UPDATE_LOG_DEPRECATED_TRANSLATED = 1316
  case ER_QUERY_INTERRUPTED = 1317
  case ER_SP_WRONG_NO_OF_ARGS = 1318
  case ER_SP_COND_MISMATCH = 1319
  case ER_SP_NORETURN = 1320
  case ER_SP_NORETURNEND = 1321
  case ER_SP_BAD_CURSOR_QUERY = 1322
  case ER_SP_BAD_CURSOR_SELECT = 1323
  case ER_SP_CURSOR_MISMATCH = 1324
  case ER_SP_CURSOR_ALREADY_OPEN = 1325
  case ER_SP_CURSOR_NOT_OPEN = 1326
  case ER_SP_UNDECLARED_VAR = 1327
  case ER_SP_WRONG_NO_OF_FETCH_ARGS = 1328
  case ER_SP_FETCH_NO_DATA = 1329
  case ER_SP_DUP_PARAM = 1330
  case ER_SP_DUP_VAR = 1331
  case ER_SP_DUP_COND = 1332
  case ER_SP_DUP_CURS = 1333
  case ER_SP_CANT_ALTER = 1334
  case ER_SP_SUBSELECT_NYI = 1335
  case ER_STMT_NOT_ALLOWED_IN_SF_OR_TRG = 1336
  case ER_SP_VARCOND_AFTER_CURSHNDLR = 1337
  case ER_SP_CURSOR_AFTER_HANDLER = 1338
  case ER_SP_CASE_NOT_FOUND = 1339
  case ER_FPARSER_TOO_BIG_FILE = 1340
  case ER_FPARSER_BAD_HEADER = 1341
  case ER_FPARSER_EOF_IN_COMMENT = 1342
  case ER_FPARSER_ERROR_IN_PARAMETER = 1343
  case ER_FPARSER_EOF_IN_UNKNOWN_PARAMETER = 1344
  case ER_VIEW_NO_EXPLAIN = 1345
  case ER_FRM_UNKNOWN_TYPE = 1346
  case ER_WRONG_OBJECT = 1347
  case ER_NONUPDATEABLE_COLUMN = 1348
  case ER_VIEW_SELECT_DERIVED = 1349
  case ER_VIEW_SELECT_CLAUSE = 1350
  case ER_VIEW_SELECT_VARIABLE = 1351
  case ER_VIEW_SELECT_TMPTABLE = 1352
  case ER_VIEW_WRONG_LIST = 1353
  case ER_WARN_VIEW_MERGE = 1354
  case ER_WARN_VIEW_WITHOUT_KEY = 1355
  case ER_VIEW_INVALID = 1356
  case ER_SP_NO_DROP_SP = 1357
  case ER_SP_GOTO_IN_HNDLR = 1358
  case ER_TRG_ALREADY_EXISTS = 1359
  case ER_TRG_DOES_NOT_EXIST = 1360
  case ER_TRG_ON_VIEW_OR_TEMP_TABLE = 1361
  case ER_TRG_CANT_CHANGE_ROW = 1362
  case ER_TRG_NO_SUCH_ROW_IN_TRG = 1363
  case ER_NO_DEFAULT_FOR_FIELD = 1364
  case ER_DIVISION_BY_ZERO = 1365
  case ER_TRUNCATED_WRONG_VALUE_FOR_FIELD = 1366
  case ER_ILLEGAL_VALUE_FOR_TYPE = 1367
  case ER_VIEW_NONUPD_CHECK = 1368
  case ER_VIEW_CHECK_FAILED = 1369
  case ER_PROCACCESS_DENIED_ERROR = 1370
  case ER_RELAY_LOG_FAIL = 1371
  case ER_PASSWD_LENGTH = 1372
  case ER_UNKNOWN_TARGET_BINLOG = 1373
  case ER_IO_ERR_LOG_INDEX_READ = 1374
  case ER_BINLOG_PURGE_PROHIBITED = 1375
  case ER_FSEEK_FAIL = 1376
  case ER_BINLOG_PURGE_FATAL_ERR = 1377
  case ER_LOG_IN_USE = 1378
  case ER_LOG_PURGE_UNKNOWN_ERR = 1379
  case ER_RELAY_LOG_INIT = 1380
  case ER_NO_BINARY_LOGGING = 1381
  case ER_RESERVED_SYNTAX = 1382
  case ER_WSAS_FAILED = 1383
  case ER_DIFF_GROUPS_PROC = 1384
  case ER_NO_GROUP_FOR_PROC = 1385
  case ER_ORDER_WITH_PROC = 1386
  case ER_LOGGING_PROHIBIT_CHANGING_OF = 1387
  case ER_NO_FILE_MAPPING = 1388
  case ER_WRONG_MAGIC = 1389
  case ER_PS_MANY_PARAM = 1390
  case ER_KEY_PART_0 = 1391
  case ER_VIEW_CHECKSUM = 1392
  case ER_VIEW_MULTIUPDATE = 1393
  case ER_VIEW_NO_INSERT_FIELD_LIST = 1394
  case ER_VIEW_DELETE_MERGE_VIEW = 1395
  case ER_CANNOT_USER = 1396
  case ER_XAER_NOTA = 1397
  case ER_XAER_INVAL = 1398
  case ER_XAER_RMFAIL = 1399
  case ER_XAER_OUTSIDE = 1400
  case ER_XAER_RMERR = 1401
  case ER_XA_RBROLLBACK = 1402
  case ER_NONEXISTING_PROC_GRANT = 1403
  case ER_PROC_AUTO_GRANT_FAIL = 1404
  case ER_PROC_AUTO_REVOKE_FAIL = 1405
  case ER_DATA_TOO_LONG = 1406
  case ER_SP_BAD_SQLSTATE = 1407
  case ER_STARTUP = 1408
  case ER_LOAD_FROM_FIXED_SIZE_ROWS_TO_VAR = 1409
  case ER_CANT_CREATE_USER_WITH_GRANT = 1410
  case ER_WRONG_VALUE_FOR_TYPE = 1411
  case ER_TABLE_DEF_CHANGED = 1412
  case ER_SP_DUP_HANDLER = 1413
  case ER_SP_NOT_VAR_ARG = 1414
  case ER_SP_NO_RETSET = 1415
  case ER_CANT_CREATE_GEOMETRY_OBJECT = 1416
  case ER_FAILED_ROUTINE_BREAK_BINLOG = 1417
  case ER_BINLOG_UNSAFE_ROUTINE = 1418
  case ER_BINLOG_CREATE_ROUTINE_NEED_SUPER = 1419
  case ER_EXEC_STMT_WITH_OPEN_CURSOR = 1420
  case ER_STMT_HAS_NO_OPEN_CURSOR = 1421
  case ER_COMMIT_NOT_ALLOWED_IN_SF_OR_TRG = 1422
  case ER_NO_DEFAULT_FOR_VIEW_FIELD = 1423
  case ER_SP_NO_RECURSION = 1424
  case ER_TOO_BIG_SCALE = 1425
  case ER_TOO_BIG_PRECISION = 1426
  case ER_M_BIGGER_THAN_D = 1427
  case ER_WRONG_LOCK_OF_SYSTEM_TABLE = 1428
  case ER_CONNECT_TO_FOREIGN_DATA_SOURCE = 1429
  case ER_QUERY_ON_FOREIGN_DATA_SOURCE = 1430
  case ER_FOREIGN_DATA_SOURCE_DOESNT_EXIST = 1431
  case ER_FOREIGN_DATA_STRING_INVALID_CANT_CREATE = 1432
  case ER_FOREIGN_DATA_STRING_INVALID = 1433
  case ER_CANT_CREATE_FEDERATED_TABLE = 1434
  case ER_TRG_IN_WRONG_SCHEMA = 1435
  case ER_STACK_OVERRUN_NEED_MORE = 1436
  case ER_TOO_LONG_BODY = 1437
  case ER_WARN_CANT_DROP_DEFAULT_KEYCACHE = 1438
  case ER_TOO_BIG_DISPLAYWIDTH = 1439
  case ER_XAER_DUPID = 1440
  case ER_DATETIME_FUNCTION_OVERFLOW = 1441
  case ER_CANT_UPDATE_USED_TABLE_IN_SF_OR_TRG = 1442
  case ER_VIEW_PREVENT_UPDATE = 1443
  case ER_PS_NO_RECURSION = 1444
  case ER_SP_CANT_SET_AUTOCOMMIT = 1445
  case ER_MALFORMED_DEFINER = 1446
  case ER_VIEW_FRM_NO_USER = 1447
  case ER_VIEW_OTHER_USER = 1448
  case ER_NO_SUCH_USER = 1449
  case ER_FORBID_SCHEMA_CHANGE = 1450
  case ER_ROW_IS_REFERENCED_2 = 1451
  case ER_NO_REFERENCED_ROW_2 = 1452
  case ER_SP_BAD_VAR_SHADOW = 1453
  case ER_TRG_NO_DEFINER = 1454
  case ER_OLD_FILE_FORMAT = 1455
  case ER_SP_RECURSION_LIMIT = 1456
  case ER_SP_PROC_TABLE_CORRUPT = 1457
  case ER_SP_WRONG_NAME = 1458
  case ER_TABLE_NEEDS_UPGRADE = 1459
  case ER_SP_NO_AGGREGATE = 1460
  case ER_MAX_PREPARED_STMT_COUNT_REACHED = 1461
  case ER_VIEW_RECURSIVE = 1462
  case ER_NON_GROUPING_FIELD_USED = 1463
  case ER_TABLE_CANT_HANDLE_SPKEYS = 1464
  case ER_ILLEGAL_HA_CREATE_OPTION = 1465
  case ER_PARTITION_REQUIRES_VALUES_ERROR = 1466
  case ER_PARTITION_WRONG_VALUES_ERROR = 1467
  case ER_PARTITION_MAXVALUE_ERROR = 1468
  case ER_PARTITION_SUBPARTITION_ERROR = 1469
  case ER_PARTITION_SUBPART_MIX_ERROR = 1470
  case ER_PARTITION_WRONG_NO_PART_ERROR = 1471
  case ER_PARTITION_WRONG_NO_SUBPART_ERROR = 1472
  case ER_CONST_EXPR_IN_PARTITION_FUNC_ERROR = 1473
  case ER_NO_CONST_EXPR_IN_RANGE_OR_LIST_ERROR = 1474
  case ER_FIELD_NOT_FOUND_PART_ERROR = 1475
  case ER_LIST_OF_FIELDS_ONLY_IN_HASH_ERROR = 1476
  case ER_INCONSISTENT_PARTITION_INFO_ERROR = 1477
  case ER_PARTITION_FUNC_NOT_ALLOWED_ERROR = 1478
  case ER_PARTITIONS_MUST_BE_DEFINED_ERROR = 1479
  case ER_RANGE_NOT_INCREASING_ERROR = 1480
  case ER_INCONSISTENT_TYPE_OF_FUNCTIONS_ERROR = 1481
  case ER_MULTIPLE_DEF_CONST_IN_LIST_PART_ERROR = 1482
  case ER_PARTITION_ENTRY_ERROR = 1483
  case ER_MIX_HANDLER_ERROR = 1484
  case ER_PARTITION_NOT_DEFINED_ERROR = 1485
  case ER_TOO_MANY_PARTITIONS_ERROR = 1486
  case ER_SUBPARTITION_ERROR = 1487
  case ER_CANT_CREATE_HANDLER_FILE = 1488
  case ER_BLOB_FIELD_IN_PART_FUNC_ERROR = 1489
  case ER_UNIQUE_KEY_NEED_ALL_FIELDS_IN_PF = 1490
  case ER_NO_PARTS_ERROR = 1491
  case ER_PARTITION_MGMT_ON_NONPARTITIONED = 1492
  case ER_FOREIGN_KEY_ON_PARTITIONED = 1493
  case ER_DROP_PARTITION_NON_EXISTENT = 1494
  case ER_DROP_LAST_PARTITION = 1495
  case ER_COALESCE_ONLY_ON_HASH_PARTITION = 1496
  case ER_REORG_HASH_ONLY_ON_SAME_NO = 1497
  case ER_REORG_NO_PARAM_ERROR = 1498
  case ER_ONLY_ON_RANGE_LIST_PARTITION = 1499
  case ER_ADD_PARTITION_SUBPART_ERROR = 1500
  case ER_ADD_PARTITION_NO_NEW_PARTITION = 1501
  case ER_COALESCE_PARTITION_NO_PARTITION = 1502
  case ER_REORG_PARTITION_NOT_EXIST = 1503
  case ER_SAME_NAME_PARTITION = 1504
  case ER_NO_BINLOG_ERROR = 1505
  case ER_CONSECUTIVE_REORG_PARTITIONS = 1506
  case ER_REORG_OUTSIDE_RANGE = 1507
  case ER_PARTITION_FUNCTION_FAILURE = 1508
  case ER_PART_STATE_ERROR = 1509
  case ER_LIMITED_PART_RANGE = 1510
  case ER_PLUGIN_IS_NOT_LOADED = 1511
  case ER_WRONG_VALUE = 1512
  case ER_NO_PARTITION_FOR_GIVEN_VALUE = 1513
  case ER_FILEGROUP_OPTION_ONLY_ONCE = 1514
  case ER_CREATE_FILEGROUP_FAILED = 1515
  case ER_DROP_FILEGROUP_FAILED = 1516
  case ER_TABLESPACE_AUTO_EXTEND_ERROR = 1517
  case ER_WRONG_SIZE_NUMBER = 1518
  case ER_SIZE_OVERFLOW_ERROR = 1519
  case ER_ALTER_FILEGROUP_FAILED = 1520
  case ER_BINLOG_ROW_LOGGING_FAILED = 1521
  case ER_BINLOG_ROW_WRONG_TABLE_DEF = 1522
  case ER_BINLOG_ROW_RBR_TO_SBR = 1523
  case ER_EVENT_ALREADY_EXISTS = 1524
  case ER_EVENT_STORE_FAILED = 1525
  case ER_EVENT_DOES_NOT_EXIST = 1526
  case ER_EVENT_CANT_ALTER = 1527
  case ER_EVENT_DROP_FAILED = 1528
  case ER_EVENT_INTERVAL_NOT_POSITIVE_OR_TOO_BIG = 1529
  case ER_EVENT_ENDS_BEFORE_STARTS = 1530
  case ER_EVENT_EXEC_TIME_IN_THE_PAST = 1531
  case ER_EVENT_OPEN_TABLE_FAILED = 1532
  case ER_EVENT_NEITHER_M_EXPR_NOR_M_AT = 1533
  case ER_COL_COUNT_DOESNT_MATCH_CORRUPTED = 1534
  case ER_CANNOT_LOAD_FROM_TABLE = 1535
  case ER_EVENT_CANNOT_DELETE = 1536
  case ER_EVENT_COMPILE_ERROR = 1537
  case ER_EVENT_SAME_NAME = 1538
  case ER_EVENT_DATA_TOO_LONG = 1539
  case ER_DROP_INDEX_FK = 1540
  case ER_WARN_DEPRECATED_SYNTAX = 1541
  case ER_CANT_WRITE_LOCK_LOG_TABLE = 1542
  case ER_CANT_READ_LOCK_LOG_TABLE = 1543
  case ER_FOREIGN_DUPLICATE_KEY = 1544
  case ER_COL_COUNT_DOESNT_MATCH_PLEASE_UPDATE = 1545
  case ER_REMOVED_SPACES = 1546
  case ER_TEMP_TABLE_PREVENTS_SWITCH_OUT_OF_RBR = 1547
  case ER_STORED_FUNCTION_PREVENTS_SWITCH_BINLOG_FORMAT = 1548
  case ER_NDB_CANT_SWITCH_BINLOG_FORMAT = 1549
  case ER_PARTITION_NO_TEMPORARY = 1550
  case ER_PARTITION_CONST_DOMAIN_ERROR = 1551
  case ER_PARTITION_FUNCTION_IS_NOT_ALLOWED = 1552
  case ER_DDL_LOG_ERROR = 1553
  case ER_NULL_IN_VALUES_LESS_THAN = 1554
  case ER_WRONG_PARTITION_NAME = 1555
  case ER_CANT_CHANGE_TX_ISOLATION = 1556
  case ER_DUP_ENTRY_AUTOINCREMENT_CASE = 1557
  case ER_EVENT_MODIFY_QUEUE_ERROR = 1558
  case ER_EVENT_SET_VAR_ERROR = 1559
  case ER_PARTITION_MERGE_ERROR = 1560
  case ER_CANT_ACTIVATE_LOG = 1561
  case ER_RBR_NOT_AVAILABLE = 1562
  case ER_NO_TRIGGERS_ON_SYSTEM_SCHEMA = 1563
  case ER_CANT_ALTER_LOG_TABLE = 1564
  case ER_BAD_LOG_ENGINE = 1565
  case ER_CANT_DROP_LOG_TABLE = 1566
}
