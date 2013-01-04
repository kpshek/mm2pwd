#!/usr/bin/env ruby
# coding: UTF-8

# Copyright 2013 Kevin Shekleton
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Mm2Pwd
  attr_accessor :e_tanks, :bubble_man, :air_man, :quick_man, :wood_man, :crash_man, :flash_man, :metal_man, :heat_man

  # Initializes an instance of this class with the desired password properties.
  # Change the instance variable values here to change the generated password.
  #
  # Returns an instance of Mm2Pwd.
  def initialize
    @e_tanks = 4

    # alive (true) ; defeated (false)
    @bubble_man = false
    @air_man = false
    @quick_man = false
    @wood_man = false
    @crash_man = false
    @flash_man = false
    @metal_man = false
    @heat_man = false
  end

  # Public: Generates the password coordinates suitable for input in Mega Man 2.
  #
  # This method will also print the 25-bit password and coordinates to the console.
  #
  # Returns the Array of password coordinates (Strings) for this class.
  def generate
    bits = generate_password_bits
    puts bits.to_s(2)

    coordinates = bits_to_coordinates(bits)
    puts coordinates.inspect

    coordinates
  end

  private

  # Internal: Generates the password bits (1-25).
  #
  # Returns the 25-bit password (Integer) for this class.
  def generate_password_bits
    # row    E     D     C     B
    bits = 0b00000_00000_00000_00000

    # Determine the boss bits (bits 1-20)
    bits |= @bubble_man ? 0b00000_00000_00100_00000 : 0b00000_00001_00000_00000 # C3 / D1
    bits |= @air_man    ? 0b00000_00010_00000_00000 : 0b00100_00000_00000_00000 # D2 / E3
    bits |= @quick_man  ? 0b00000_00000_01000_00000 : 0b00000_00000_00000_01000 # C4 / B4
    bits |= @wood_man   ? 0b00000_00000_00000_10000 : 0b00000_00100_00000_00000 # B5 / D3
    bits |= @crash_man  ? 0b00010_00000_00000_00000 : 0b00000_00000_10000_00000 # E2 / C5
    bits |= @flash_man  ? 0b01000_00000_00000_00000 : 0b00000_00000_00001_00000 # E4 / C1
    bits |= @metal_man  ? 0b00001_00000_00000_00000 : 0b10000_00000_00000_00000 # E1 / E5
    bits |= @heat_man   ? 0b00000_10000_00000_00000 : 0b00000_00000_00000_00010 # D5 / B2

    # Rotate bits left based on the number of E-Tanks
    bits = rotate_left(bits, @e_tanks)

    # Set the E-Tank bits
    bits |= (1 << 20 + @e_tanks)

    bits
  end

  # Internal: Given the following bits, returns the coordinates of the set bits.
  #
  # bits - [Integer] The 25-bit password.
  #
  # Examples
  #
  #   bits_to_coordinates(0b10000_01000_00100_00010_00011)
  #   # => ['A5', 'B1', 'B2', 'C2', 'D3', 'E4']
  #
  # Returns the coordinates of the set bits expressed in terms of the grid.
  def bits_to_coordinates(bits)
    a = (bits & 0b11111_00000_00000_00000_00000) >> 20
    e = (bits & 0b11111_00000_00000_00000) >> 15
    d = (bits & 0b11111_00000_00000) >> 10
    c = (bits & 0b11111_00000) >> 5
    b = bits & 0b11111

    coordinates = []

    coordinates.push(*word_to_coordinates(:A, a))
    coordinates.push(*word_to_coordinates(:B, b))
    coordinates.push(*word_to_coordinates(:C, c))
    coordinates.push(*word_to_coordinates(:D, d))
    coordinates.push(*word_to_coordinates(:E, e))
  end

  # Internal: Given the following word, returns the coordinates of the set bits.
  #
  # row_name - [Symbol] The name of the row being evaluated
  # word     - [Integer] The word (5 bits) being evaluated
  #
  # Examples
  #
  #   word_to_coordinates(:B, 0b01101)
  #   # => ['B1', 'B3', 'B4']
  #
  # Returns a non-nil Array of the coordinates that are 'set'.
  def word_to_coordinates(row_name, word)
    coordinates = []
    5.times do |i|
      coordinates << "#{row_name}#{i+1}" if (word & (1 << i)) > 0
    end

    coordinates
  end

  # Internal: Rotate the bits of the given value left by the given shift
  # Note that a word size of 20 is assumed
  #
  # value - [Integer] The bit value to shift
  # shift - [Integer] The number of left shifts
  #
  # Examples
  #
  #   rotate_left(0b01010_00000_00000_00000, 2)
  #   # => 0b01000_00000_00000_00001
  #
  # Returns the given value left shifted by the given shift.
  def rotate_left(value, shift)
    ((value << shift) | (value >> (20 - shift))) & 0xFFFFF
  end
end

Mm2Pwd.new.generate