# Converts a radix 16 (Hex) string to a Base64 encoded string
# Usage: HexToBase64.new('12AB34').convert # => 'Eqs0'
class HexToBase64
  def initialize(hex)
    @hex = hex
  end

  # Returns the Base64 equivalent
  def convert
    binary = hex_to_binary
    groups_of_6_bits(binary).map do |group|
      index = binary_group_to_base64_index(group)
      base64_mapping[index.to_s]
    end.join
  end

  private

  # Taking 6 binary digits at a time because 2**6 == 64
  # This is the maximum binary value that can be represented by individual Base64 values
  def groups_of_6_bits(binary)
    binary.to_s.scan(/.{1,6}/)
  end

  def binary_group_to_base64_index(binary)
    binary = binary.to_s
    values = []
    binary.split('').reverse.each_with_index do |char, index|
      values << Integer(char, 2) * (2**index)
    end
    values.inject(&:+)
  end

  # Take the hex value (radix 16) and convert this to binary (radix 2)
  # This is accomplished by mapping each character in the hex string
  # to its corresponding binary representation
  def hex_to_binary
    @hex.split('').map do |char|
      hex_to_binary_mapping[char]
    end.join('')
  end

  def hex_to_binary_mapping
    {
      '0' => '0000',
      '1' => '0001',
      '2' => '0010',
      '3' => '0011',
      '4' => '0100',
      '5' => '0101',
      '6' => '0110',
      '7' => '0111',
      '8' => '1000',
      '9' => '1001',
      'A' => '1010',
      'B' => '1011',
      'C' => '1100',
      'D' => '1101',
      'E' => '1110',
      'F' => '1111'
    }
  end

  def base64_mapping
    @mapping ||= (
      chars = ('A'..'Z').to_a.push(*('a'..'z').to_a).push(*(0..9).to_a).push('+').push('/')
      hash = {}
      chars.each_with_index do |char, index|
        hash[index.to_s] = char
      end
      hash
    )
  end
end
