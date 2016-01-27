/* Copyright 2015 Samsung Electronics Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
  @TIMEOUT=10
  @SKIP
    skip this test for there is no way to automatically confirm
    correctness of gpio behavior on host machine.
*/

var assert = require('assert');
var gpio = require('gpio');


gpio.initialize();

gpio.on('initialize', function() {
  console.log("initialized");
  gpio.setPin(1, "out");
});

gpio.on('release', function() {
  console.log('released');
});

gpio.on('error', function(err) {
  console.log('error: ' + err);
});
