RSpec.describe Nmax do

	it "::VERSION" do
		expect(Nmax::VERSION).not_to be nil
	end
	
	context "Initialization" do
		it "STDReader.new(5) - OK" do 
			expect(Nmax::STDReader.new(5)).to be_an(Nmax::STDReader)
		end	
		
		it "STDReader.new(-1) - FAIL" do 
			expect{Nmax::STDReader.new(-1)}.to raise_error('nmax N # N must be greater than zero')
		end	
		
		it "STDReader.new('hello') - FAIL" do 
			expect{Nmax::STDReader.new('hello')}.to raise_error('nmax N # N must be integer')
		end	
	end 

	context "Regexp" do
		let(:nmaxSTRReader) { Nmax::STDReader.new(5)}

		it "STDReader.regular_with_min_digits(1)" do
			expect(nmaxSTRReader.regular_with_min_digits(1)).to eq(/(\d{1,1000}$)|(\d{1,1000})/)
		end

		it "STDReader.regular_with_min_digits(5)" do
			expect(nmaxSTRReader.regular_with_min_digits(5)).to eq(/(\d{1,1000}$)|(\d{5,1000})/)
		end
	end

	context 'String "1-2-3-4-5"' do 
		let(:nmaxSTRReader) { Nmax::STDReader.new(5)}

		it "STDReader.get_numbers - should be eq 1,2,3,4" do
			nmaxSTRReader.get_numbers('1-2-3-4-5')
			expect(nmaxSTRReader.getted_numbers).to eq(SortedSet.new([1,2,3,4]))
		end

		it "STDReader.tail_digits - should be 5" do
			nmaxSTRReader.get_numbers('1-2-3-4-5')
			expect(nmaxSTRReader.tail_digits).to eq('5')
		end
		
		it "STDReader.max_numbers" do
			nmaxSTRReader.get_numbers('1-2-3-4-5')
			expect(nmaxSTRReader.max_numbers).to eq([1,2,3,4,5])
		end
	end

	context 'Strings "1-2-3-4-5" & "0-51a"' do 
		
		before(:all) do
			@nmaxSTRReader = Nmax::STDReader.new(3)
			@nmaxSTRReader.get_numbers('1-2-3-4-5')    
		end

		it "STDReader.tail_digits - tail eq 5 (str1)" do
			expect(@nmaxSTRReader.tail_digits).to eq('5')
		end

		it "STDReader.tail_digits - tail should be empty (str2)" do
			@nmaxSTRReader.get_numbers('0-51a')
			expect(@nmaxSTRReader.tail_digits).to eq('')
		end

		it "STDReader.max_numbers - should be 4,50,51" do
			@nmaxSTRReader.get_numbers('0-51a')
			expect(@nmaxSTRReader.max_numbers).to eq([4,50,51])
		end
	end
	
	context 'Reader max number size = 2, Str "309050521231123"' do 
		before(:all) do
			@nmaxSTRReader = Nmax::STDReader.new(3)
			@nmaxSTRReader.max_size = 2
			@nmaxSTRReader.get_numbers('309050521231123')    
		end
		
		it "STDReader.regular_with_min_digits(5)" do 
			expect(@nmaxSTRReader.regular_with_min_digits(2)).to  eq(/(\d{1,2}$)|(\d{2,2})/)
		end  
		
		it "STDReader.tail_digits - tail eq 3" do
			expect(@nmaxSTRReader.tail_digits).to eq('3')
		end

		it "STDReader.tail_digits - tail should not be empty" do
			expect(@nmaxSTRReader.tail_digits).not_to eq('')
		end

		it "STDReader.max_numbers - should be 50,52,90" do
			expect(@nmaxSTRReader.max_numbers).to eq([50,52,90])
		end
	end
	
	context 'String without digits' do 
		before(:all) do
			@nmaxSTRReader = Nmax::STDReader.new(3)
			@nmaxSTRReader.max_size = 2
			@nmaxSTRReader.get_numbers('abcdefgj')    
		end

		it "STDReader.get_numbers - tail should be empty" do
			expect(@nmaxSTRReader.tail_digits).to eq('')
		end

		it "STDReader.max_numbers - should be empty" do
			expect(@nmaxSTRReader.max_numbers).to eq([])
		end
	end
end
