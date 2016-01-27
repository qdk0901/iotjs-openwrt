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

#include <stdio.h>
#include <stdarg.h>
#include "jerry-port.h"

extern "C" int iotjs_entry(int argc, char** argv);

int jerry_port_logmsg (FILE* stream, const char* format, ...)
{
	va_list args;
	int count;
	va_start (args, format);
	count = vfprintf (stream, format, args);
	va_end (args);
	return count;
}

int jerry_port_errormsg (const char* format, ...)
{
	va_list args;
	int count;
	va_start (args, format);
	count = vfprintf (stderr, format, args);
	va_end (args);
	return count;
}

int jerry_port_putchar (int c)
{
	return putchar (c);
}

int main(int argc, char** argv) {

  return iotjs_entry(argc,argv);

}
