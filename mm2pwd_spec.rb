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

require './mm2pwd'

describe Mm2Pwd do
  let(:m) { Mm2Pwd.new }

  context '#initialize' do
    it 'returns a non-nill instance' do
      m.should be_an_instance_of(Mm2Pwd)
    end
  end

  context '#generate' do
    it 'returns the correct coordinates for 4 E-Tanks and all 8 bosses defeated' do
      expect(m.generate).to eq(['A5', 'B2', 'B4', 'C1', 'C3', 'C5', 'D4', 'D5', 'E2'])
    end

    it 'returns the correct coordinates for 0 E-Tanks and all 8 bosses defeated' do
      m.e_tanks = 0
      expect(m.generate).to eq(['A1', 'B2', 'B4', 'C1', 'C5', 'D1', 'D3', 'E3', 'E5'])
    end
  end

  context '#generate_password_bits' do
    it 'returns the correct bits for 4 E-Tanks and all 8 bosses defeated' do
      expect(m.send(:generate_password_bits)).to eq(0b10000_00010_11000_10101_01010)
    end
  end

  context '#bits_to_coordinates' do
    it 'returns no coordinates if all bits are unset' do
      expect(m.send(:bits_to_coordinates, 0b00000_00000_00000_00000_00000)).to eq([])
    end

    it 'correctly pulls the 1st word (B)' do
      expect(m.send(:bits_to_coordinates, 0b00000_00000_00000_00000_01110)).to eq(['B2', 'B3', 'B4'])
    end

    it 'correctly pulls the 2nd word (C)' do
      expect(m.send(:bits_to_coordinates, 0b00000_00000_00000_11011_00000)).to eq(['C1', 'C2', 'C4', 'C5'])
    end

    it 'correctly pulls the 3rd word (D)' do
      expect(m.send(:bits_to_coordinates, 0b00000_00000_00110_00000_00000)).to eq(['D2', 'D3'])
    end

    it 'correctly pulls the 4th word (E)' do
      expect(m.send(:bits_to_coordinates, 0b00000_01001_00000_00000_00000)).to eq(['E1', 'E4'])
    end

    it 'correctly pulls the 5th word (A)' do
      expect(m.send(:bits_to_coordinates, 0b10010_00000_00000_00000_00000)).to eq(['A2', 'A5'])
    end
  end

  context '#word_to_coordinates' do
    it 'correctly identifies the set bits when all bits are set' do
      expect(m.send(:word_to_coordinates, :A, 0b11111)).to eq(['A1', 'A2', 'A3', 'A4', 'A5'])
    end

    it 'correctly identifies the set bits when all bits are unset' do
      expect(m.send(:word_to_coordinates, :A, 0b00000)).to eq([])
    end

    it 'correctly identifies the set bits when there are a mixture of set and unset bits' do
      expect(m.send(:word_to_coordinates, :A, 0b01010)).to eq(['A2', 'A4'])
    end
  end

  context '#rotate_left' do
    it 'correctly does not rotate if the shift is 0' do
      expect(m.send(:rotate_left, 0b10000_00000_00000_00000, 0)).to eq(0b10000_00000_00000_00000)
    end

    it 'correctly rotates and wraps values for a shift of 1' do
      expect(m.send(:rotate_left, 0b10100_00000_00000_00000, 1)).to eq(0b01000_00000_00000_00001)
    end

    it 'correctly rotates and wraps values for a shift of 2' do
      expect(m.send(:rotate_left, 0b10100_00000_00000_00000, 2)).to eq(0b10000_00000_00000_00010)
    end
  end
end
