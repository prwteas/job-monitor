class StreamStart

end

class ImportJobs
  @queue = :jobs

  def self.perform
    Job.fetch_jobs
    Job.check_if_removed
  end
end

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
  field :loc_country, type: String
  field :closed_at, type: Time
  field :track_code,type: String

  index({ jobid: 1 }, { unique: true })

  scope :open, where(:closed_at => nil)
  scope :closed, ne(:closed_at=>nil)

  def self.fetch_jobs
    agent     = Mechanize.new
    page      = agent.get('http://www.booking.com/jobs.html')
    countries = page.link_with(:text => "See all jobs").click.search("ul.countries li a").map(&:text)

    jobs = page.link_with(:text => "See all jobs")
    countries.each do |country|
      jobs.click.link_with(:text => country).click.links_with(:href=>/job_id/).each do |element|
        jb = element.click.search("div#job_detail p.meta").text.split("\n")
        j             = Job.new
        j.loc_country = country
        #j.title       = element.children[1].text
        j.title       = element.text
        j.joblink     = element.href
        #j.joblink     = element.children[1]['href']
        j.jobid       = element.href.scan(/\d+/).last
        #j.jobid       = element.children[1]['href'].scan(/\d+/).last
        #j.city        = element.children[3].text.scan(/\w+/).last
        j.city        = jb[1]
        #j.burb        = element.children[3].text
        j.type        = jb[2]
        #j.type        = element.children[3].text.scan(/\b\w+\-\w+\/\w+\b/).first
        j.department  = jb[3]

        #j.department  = element.children[3].text.scan(/^(?:.+)(?=\s+\b\w+\-\w+\/\w+\b)/).first
        j.save
      end
    end
    create_snapshot

  end

  def self.create_snapshot
    sn=Dbsnap.new
    sn.open=Job.open.count
    sn.closed=Job.closed.count
    sn.save
  end

  def self.check_if_removed
    agent      = Mechanize.new
    page       = agent.get('http://www.booking.com/jobs.html')
    countries  = page.link_with(:text => "See all jobs").click.search("ul.countries li a").map(&:text)
    jobs       = page.link_with(:text => "See all jobs")
    remotejobid=[]
    countries.each do |country|
      remotejobid << jobs.click.link_with(:text => country).click.search("div#country_or_category ul li").map { |i| i.children[1]['href'].scan(/\d+/).last }

    end

    localjobid = Job.where(:closed_at => nil).map(&:jobid)
    closed     = localjobid - remotejobid.flatten
    closed.each { |job_id| p = Job.where(:jobid => job_id).first; p.closed_at=Time.now; p.save }
  end

  def self.async_import
    Resque.enqueue(ImportJobs)
  end


end
