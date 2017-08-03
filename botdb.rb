

class DB

  def initialize(db)
    @databasename=db
    @database = Array.new
    @sterms = Array.new
    @resultdata = Array.new
  end
  def load
    if File.exist?("#{@databasename}")
      p "- Found existing #{@databasename}"
      @database = IO.readlines("#{@databasename}")
      p "- imported #{@database.size} facts"
      return @database.size
    else
      p "- #{@databasename} not found"
    end
  end
  def save
    savefile = File.open("#{@databasename}", "w")
    @database.each do |entry|
      savefile.puts(entry)
    end
    savefile.close
    return @database.size
  end
  def size
    p "#{@database}"
    return @database.size
  end
  def append(data)
      @database << data 
      savefile = File.open("#{@databasename}", "a")
        savefile.puts(data)
      savefile.close 
  end

  def query(instring)
    #p "in query #{instring}"
    @scoredata = Array.new(@database.size, 0)
    #p "created scorearray"
    #p "instring: #{instring}"
    # added gsub to remove punctuation from search string
    @stermstring = instring.downcase.gsub(/[^a-z\s]/, '')
    #p "downcased query: #{@stermstring}"
    #load "bot_blockwords.rb"
    #@blockwords = ["tcmbot:", " a ", " an ", " and ", " are ", " as ", " at ", " be ", " by ", " for ", " from ", " has ", " he ", " in ", " is ", " it ", " of ", " on ", " that ", " the ", " to ", " was ", " were ", " will ", " with ", " my "]
    @blockwords = ["tcmbot:", "a","about","above","after","again","against","all","am","an","and","any","are","aren't","as","at","be","because","been","before","being","below","between","both","but","by","cannot","can't","could","couldn't","did","didn't","do","does","doesn't","doing","don't","down","during","each","few","for","from","further","had","hadn't","has","hasn't","have","haven't","having","he","he'd","he'll","her","here","here's","hers","herself","he's","him","himself","his","how","how's","i","i'd","if","i'll","i'm","in","into","is","isn't","it","its","it's","itself","i've","let's","me","more","most","mustn't","my","myself","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","over","own","same","shan't","she","she'd","she'll","she's","should","shouldn't","so","some","such","than","that","that's","the","their","theirs","them","themselves","then","there","there's","these","they","they'd","they'll","they're","they've","this","those","through","to","too","under","until","up","very","was","wasn't","we","we'd","we'll","were","we're","weren't","we've","what","what's","when","when's","where","where's","which","while","who","whom","who's","why","why's","with","won't","would","wouldn't","you","you'd","you'll","your","you're","yours","yourself","yourselves","you've"]
    #@blockwords.each { |word| @stermstring.gsub!(word," ") }
    @blockwords.each { |word| @stermstring.gsub!( /\b#{Regexp.escape(word)}s?\b/, " " ) }
    @sterms = @stermstring.split(" ")
    #p "filtered query = #{@sterms}"
    # Do search for each search term
    @sterms.each do |sterm|
      #p "working on sterm: #{sterm}"
      #p "database: #{@database}"
      @database.each_with_index do |val, index|
        #puts "- searching #{index}, value #{val}"
        #if val.downcase.include?(sterm) then
        val.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        if val.downcase =~ /\b#{Regexp.escape(sterm)}s?\b/ then
          puts "Found match for #{sterm.downcase}, index #{index}"  #, data: #{val}" 
          @scoredata[index] += 1
        end
      end 
    end
    # Search for high score
    @highscore = 0
    @scoredata.each do |scoreval| 
      if scoreval > @highscore
        @highscore = scoreval
        #puts "High score found: #{@scoreval}"
      end
    end

    # Match highscore to index and report value
    #p "Searching for highscore #{highscore}..."
    p "High score: #{@highscore}"
    @rpointer = 0
    @resultdata.clear
    if @highscore > 0
      @spointer = 0
      until @spointer == @database.size do
        @tmp = @scoredata[@spointer]
        #p "Index #{spointer} found score #{tmp}"
        if @tmp == @highscore
          @result = @database[@spointer]
          #puts "Matched Result: #{@result}"
          #msg nick, "#{result}"
          @resultdata << @result
          #p "resultdatasize = #{@result.size}"
        end
        @spointer = @spointer + 1
      end
      @resultdatasize = @resultdata.size
      p "Found #{@resultdatasize} possible answers"
      @randomresult = rand(@resultdatasize)
      p "Picked result index #{@randomresult}"
      result = @resultdata[@randomresult]
      #p "result: #{@result.capitalize}"
      #msg channel, "#{@result.capitalize}"
      return result
    else
      return "I don't know :("
    end
  end
end

