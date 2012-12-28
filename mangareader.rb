http://www.mangareader.net/337-23512-1/historys-strongest-disciple-kenichi/chapter-6.html

class Mangareader < Manga
  attr_accessor :series, :series_id, :chapter, :chapter_id, :page

    SERIES_URL = '%(baseurl)s/%(series_id)d/%(series)s.html'
    CHAPTER_URL = '%(baseurl)s/%(series_id)d-%(chapter_id)d-1/%(series)s/chapter-%(chapter)d.html'
    PAGE_URL = '%(baseurl)s/%(series_id)d-%(chapter_id)d-%(page)d/%(series)s/chapter-%(chapter)d.html'

    @NEW_SERIES_URL = '%(baseurl)s/%(series)s'
    NEW_CHAPTER_URL = '%(baseurl)s/%(series)s/%(chapter)d'
    NEW_PAGE_URL = '%(baseurl)s/%(series)s/%(chapter)d/%(page)d'
  def initialize()
    baseurl = 'http://www.mangareader.net' 
    super(baseurl)

    @chapter_regex_1 = /(\d+)-(\d+)-(\d+)\/[^\/]+\/chapter-(\d+).html/
    @chapter_regex_2 = /[^\/]+\/(\d+)/
  end


  def get_series_url(data)
    if data[:series_id].present?
      return Manga.get_series_url(data)
    else
      @data = data
      @data[:baseurl] = @baseurl
      return NEW_SERIES_URL % d
  end

  private 

  #Receives url for the manga chapters list page
  def list_chapters(doc)
    chapters = []
    
    doc.xpath("//table[@id='listing']/tr[position()>1]").each do |n|
      url = n.xpath("td[1]/a")[0]['href']

      #compare to old chapter naming
      match = @chapter_regex_1.match(url)
      if match
        chapters << {:series_id => match[1], :chapter_id => match[2], :chapter => match[4]}
      end

      #compare to new chapter naming
      match = @chapter_regex_2.match(url)
      if match
        chapters << {:chapter => match[1]}
      end
    end
  end

  #Receives url for the manga chapter page
  def list_pages(doc)
    # Search for nodes by css
    pages = []
    doc.xpath("//select[@id='pageMenu']/option").each do |page|
      pages <<  page.text.to_i
    end
  end

  
end