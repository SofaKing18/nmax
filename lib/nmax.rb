require 'nmax/version'
require 'set'

module Nmax
	InvalidArgumentValue = Exception.new("nmax N # N must be greater than zero")
	InvalidArgumentType = Exception.new("nmax N # N must be integer")
	
	class STDReader
		attr_accessor   :batch_size,		# read data size
						:return_count, 		# return count
						:min_size,			# minimum length of number
						:max_size,			# maximum length of number 
						:getted_numbers,	# set of numbers
						:tail_digits 		# tail of data str
		
		def regular_with_min_digits(min_size) 
			Regexp.new("(\\d{1,#{@max_size}}$)|(\\d{#{min_size},#{@max_size}})")   
		end
	
		def initialize(n)
			raise InvalidArgumentValue if n < 1

			@batch_size = 1024 * 1024 * 10 # 10Mb
			@return_count = n
			@min_size = 1
			@max_size = 1000
			@tail_digits = ''
			@getted_numbers = SortedSet.new([])
		rescue ArgumentError
			raise InvalidArgumentType
		end

		def max_numbers
			# if tail exists, we need check it too
			if @tail_digits.size > 0 then
				@getted_numbers.add(@tail_digits.to_i)
			end
			@getted_numbers.to_a.last(@return_count)
		end

		def get_numbers(data_string)
			numbers = (@tail_digits+data_string).scan(regular_with_min_digits(@min_size))
			if numbers.empty? then 
				@tail_digits = ''
			else 
				# last becouse belongs to second group of regexp
				@tail_digits = (numbers.last.first || '')
				numbers.pop if numbers.last.last.nil?
				@getted_numbers.merge(numbers.map{|num| num.last.to_i})
				# first equals digits in end of readed data
				@min_size = @getted_numbers.to_a.last(@return_count).first.to_s.size || 1
			end
		end

		def read_data
			while (data_string = STDIN.read(@batch_size)) != nil
				get_numbers(data_string)
			end
		end
	end  
end
