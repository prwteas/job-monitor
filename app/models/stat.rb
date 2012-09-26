class Stat
  include Mongoid::Document


  def by_department
    sum = Hash.new(0)
    Job.all.map(&:department).each{|i| sum.store(i,sum[i]+1)}
    return sum
  end


end
