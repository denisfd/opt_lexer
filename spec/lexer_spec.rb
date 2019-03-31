describe Lexical::Lexer do
  let(:lexer) { Lexical.create }
  let(:it) { lexer.infotable }

  it 'processes pass with no errors' do
    lexer.scan_file('spec/fixtures/pass')
    expect(it.errors).to be_empty
  end

  it 'processes valid symbols with no error' do
    lexer.scan(':::=[];')
    expect(it.errors).to be_empty
    expect(it.lexems.length).to eq(6)
  end

  it 'recognizes error with position' do
    lexer.scan('  :::==[];')
    expect(it.errors).not_to be_empty
    expect(it.lexems.length).to eq(6)
    expect(it.errors.length).to eq(1)
    error = it.errors[0]
    expect(error.line).to eq(1)
    expect(error.column).to eq(7)
  end

  it 'recognizes digit as constant' do
    lexer.scan('4456252')
    expect(it.errors).to be_empty
    expect(it.lexems.length).to eq(1)
    expect(it.constants.length).to eq(1)
    expect(it.constants).to include('4456252')
  end

  it 'recognizes error in digit' do
    lexer.scan('44562a52')
    expect(it.errors).not_to be_empty
    expect(it.lexems.length).to eq(0)
    expect(it.constants.length).to eq(0)
    expect(it.constants).not_to include('4456252')
  end

  it 'recognizes word as identifier' do
    lexer.scan('PROG1')
    expect(it.errors).to be_empty
    expect(it.lexems.length).to eq(1)
    expect(it.identifiers.length).to eq(1)
    expect(it.identifiers).to include('PROG1')
  end

  it 'does notrecognizes reseved word as identifier' do
    lexer.scan('PROGRAM')
    expect(it.errors).to be_empty
    expect(it.lexems.length).to eq(1)
    expect(it.identifiers.length).to eq(0)
    expect(it.identifiers).not_to include('PROGRAM')
  end

  it 'recognize error in word' do
    lexer.scan('PRO$GRAM')
    expect(it.errors).not_to be_empty
    expect(it.lexems.length).to eq(0)
    expect(it.identifiers).not_to include('PRO$GRAM')
  end

  it 'ignores comments' do
    lexer.scan('WORD(* asjdhsajdsjahdsa %***(*%%%$$$$$%%*)345')
    expect(it.errors).to be_empty
    expect(it.lexems.length).to eq(2)
    expect(it.identifiers).to include('WORD')
    expect(it.constants).to include('345')
  end

  it 'errors if comment not closed' do
    lexer.scan('(*hello')
    expect(it.errors.length).to eq(1)
    error = it.errors[0]
    expect(error.line).to eq(1)
    expect(error.column).to eq(1)
  end

  it 'recognizes range' do
    lexer.scan('123..345')
    expect(it.errors).to be_empty

    expect(it.constants).to include('123')
    expect(it.constants).to include('345')
  end
end
