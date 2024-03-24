import 'dart:io';

import 'package:flutter/material.dart';

// 주색상
const PRIMARY_COLOR = Color(0xFF22A45D);
// 글자 색상
const BODY_TEXT_COLOR = Color(0xFF868686);
// 텍스트필드 배경 색상
const INPUT_BG_COLOR = Color(0xFFFBFBFB);
// 텍스트필드 테두리 색상
const INPUT_BORDER_COLOR = Color(0xFFF3F2F2);

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;