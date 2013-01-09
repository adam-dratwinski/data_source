class WordSource
  def initialize source
    @source     = source
    @words      = {}
    @consonants = {}
    @callbacks  = []
    @current    = -1
  end

  def next_word
    @current += 1

    if current_word
      update_words(current_word)
      update_consonants(current_word)
      call_callbacks(current_word)
    end

    current_word
  end

  def run
    true while(next_word)
  end

  def top_5_words
    run
    get_top_5(@words)
  end

  def top_5_consonants
    run
    get_top_5(@consonants)
  end

  def count
    run
    @words.count
  end

  def add_callback word, callback
    @callbacks << { :word => word, :callback => callback }
  end

  def self.load_from_text_file path
    source = File.read(path)
    self.new(source)
  end

  def self.load_from_last_user_tweets username
    source = TwitterApi.get_user_tweets(username).map(&:text).join(" ")
    self.new(source)
  end

  private

  def update_words word
    @words[current_word] = @words[current_word].to_i + 1
  end

  def update_consonants word
    word.to_s.split(//).each do |char|
      @consonants[char] = @consonants[char].to_i + 1
    end
  end

  def call_callbacks word
    @callbacks.select { |c| c[:word] == word }.each { |c| c[:callback].call(word) }
  end

  def get_top_5 elements
    elements = elements.sort { |a,b| b[1] <=> a[1] }.map { |a| a[0] }
    elements = (elements + [nil] * 5)[0..4]
    elements
  end

  def source_array
    @source_array ||= @source.split(/[ .,]/).reject(&:empty?)
  end

  def current_word
    source_array[@current]
  end
end
