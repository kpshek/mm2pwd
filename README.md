# Mega Man 2 Password Generator #

## Overview ##

[Mega Man 2](http://en.wikipedia.org/wiki/Mega_Man_2), like many games of its era, utilized a password system in order to
continue your progress between game sessions. This removed the need for a battery in the game catridge and allowed gamers
to share passwords (and thus progress) with others.

In Mega Man 2, the password is represented as a 5x5 grid in which the columns are labled 1-5 and the rows A-E. Each password
is composed of 9 cells which are 'set', indicated by a red dot.

Thus, a password can be communicated as A5, B2, B4, C1, C3, C5, D4, D5, E2.

![ScreenShot](https://raw.github.com/kpshek/mm2pwd/master/mega-man-2-password.png)

Put another way, this 5x5 grid represents 25 bits in which a password always has exactly 9 bits set. Using this representation,
the password algorithm can be expressed succinctly in terms of these bits and using basic
[bitwise operations](http://en.wikipedia.org/wiki/Bitwise_operation).

In the 25 bits, there are 5 words of 5 bits each where each word represents a row in the grid. The entire 25-bit password
is thus comprised of the words A E D C B (using little endian). So, the first word (lowest 5 bits) are the 5 bits of the row B
and the last word (bits 20-25) are the 5 bits of row A.

### Words 1-4 (bits 1-20) ###

A Mega Man 2 password has exactly 9 bits set. 8 of these bits represent the alive/defeated status of each of the
[8 bosses](http://en.wikipedia.org/wiki/Robot_Master#009-016_.28Mega_Man_2.29) in the game. The follow table illustrates the bit
values for the alive/defeated status for each of the 8 bosses.

Boss       | Alive | Defeated
---------- | ----- | --------
Bubble Man | C3    | D1
Air Man    | D2    | E3
Quick Man  | C4    | B4
Wood Man   | B5    | D3
Crash Man  | E2    | C5
Flash Man  | E4    | C1
Metal Man  | E1    | E5
Heat Man   | D5    | B2

Thus, if both Bubble Man and Air Man were defeated but all other bosses were still alive, this is represented as the following
bits (1-20) 01111 10001 01000 10000.

Row  | E     | D     | C     | B
---- | ----- | ----- | ----- | -----
Word | 01111 | 10001 | 01000 | 10000

### E-Tank Word (bits 21-25) ###

The last bit (9th) represents the number of E-Tanks Mega Man has. This is stored in the 5th word (row A) and represents bits
21-25, the most significant bits of the password. Mega Man can have between 0-4 E-Tanks and this is encoded simply per the bit
position in this last word. Thus, if Mega Man has 0 E-Tanks the word is 00001, 1 E-Tank is 00010, 2 E-Tanks is 00100, and so
forth. Unlike the other words, the 5th word (row A) will thus only ever have a single bit set.

The E-Tank word (row A) is important in that it encodes bits 1-20 by performing a
[rotate left operation](http://en.wikipedia.org/wiki/Circular_shift) on bits 1-20 by the number of E-Tanks that Mega Man has.
Thus, if Mega Man has 2 E-Tanks, bits 1-20 are rotated left by 2 positions. If Mega Man has 0 E-Tanks, this is effectively a no-op.
The table above illustrating the bits set for each of the 8 bosses represent the bits prior to the rotate left operation. The bits
of the E-Tank word are not included in the left rotation.

## Algorithm ##

The algorithm for calculating a password can be summarized as follows:

1. Set the bits of the first 4 words (rows B, C, D, E) based on the table above (bits 1-20)
2. Rotate left bits 1-20 based on the number of E-Tanks
3. Add the E-Tank word (bits 21-25) as the most significant word of the password

## Setup ##

To run mm2pwd you will need [Ruby](http://www.ruby-lang.org/) installed.
mm2pwd has been tested with Ruby 1.9.3p362 which is the latest version as of this writing.

## Running ##

To run mm2pwd, simply open a terminal session in the root directory and execute the following command:

    $ ./mm2pwd.rb

Without an modification, this will generate a password in which Mega Man has all 4 E-Tanks and has defeated all 8 bosses. If you
want to modify this, simply change the values in the initialize method.

## License ##

Copyright 2013 Kevin Shekleton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
