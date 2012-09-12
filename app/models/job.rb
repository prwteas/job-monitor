class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :joblink, type: String
  field :department, type: String
  field :city, type: String
  field :type, type: String
  field :jobid, type: String
  field :burb, type: String
  field :loc_country,type: String
  field :closed_at,type: Time

  index({jobid: 1},{unique: true})

  def self.fetch_jobs
  	agent = Mechanize.new
  	page = agent.get('http://www.booking.com/jobs.html')
  	countries = page.link_with(:text => "See all jobs").click.search("ul.countries li a").map(&:text)

  	jobs = page.link_with(:text => "See all jobs")
    remotejobid =[]
  	countries.each do |country|
  	remotejobid << jobs.click.link_with(:text=>country).click.search("div#country_or_category ul li").map{|i| i.children[1]['href'].scan(/\d+/).last}
  	jobs.click.link_with(:text=>country).click.search("div#country_or_category ul li").each do |element|
  		j = Job.new
  		j.loc_country = country
  		j.title = element.children[1].text
  		j.joblink = element.children[1]['href']
  		j.jobid = element.children[1]['href'].scan(/\d+/).last
  		j.city = element.children[3].text.scan(/\w+/).last
  		j.burb = element.children[3].text
  		j.type = element.children[3].text.scan(/\b\w+\-\w+\/\w+\b/).first
  		j.department = element.children[3].text.scan(/^(?:.+)(?=\s+\b\w+\-\w+\/\w+\b)/).first
  		j.save
  	end
  end
  	localjobid = Job.all.map(&:jobid)
  	closed = localjobid - remotejobid
  	closed.each{|job_id| p = Job.where(:jobid=>job_id).first;p.closed_at=Time.now;p.save}
end



end
