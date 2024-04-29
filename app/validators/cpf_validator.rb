class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if cpf_valid?(value)

    record.errors.add(
      attribute,
      :invalid_cpf,
      message: options[:message] || 'is not valid',
      value: value
    )
  end

  private

  DENY_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

  SIZE_VALIDATION = /^[0-9]{11}$/

  def cpf_valid?(cpf)
    cpf.gsub!(/[^\d]/, '')
    return unless cpf =~ SIZE_VALIDATION
    return if DENY_LIST.include?(cpf)

    cpf_numbers = cpf.chars.map(&:to_i)
    first_digit_valid?(cpf_numbers) && second_digit_valid?(cpf_numbers)
  end

  def first_digit_valid?(cpf_numbers)
    first_digits = cpf_numbers[0...9]
    multiplied = first_digits.map.with_index do |number, index|
      number * (10 - index)
    end

    fst_verifier_digit = 11 - (multiplied.reduce(:+) % 11)
    fst_verifier_digit = 0 if fst_verifier_digit > 9
    fst_verifier_digit == cpf_numbers[9]
  end

  def second_digit_valid?(cpf_numbers)
    second_digits = cpf_numbers[0...10]
    multiplied = second_digits.map.with_index do |number, index|
      number * (11 - index)
    end

    snd_verifier_digit = 11 - (multiplied.reduce(:+) % 11)
    snd_verifier_digit = 0 if snd_verifier_digit > 9
    snd_verifier_digit == cpf_numbers[10]
  end
end