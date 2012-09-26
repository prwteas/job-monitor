class StatsController < ApplicationController

  def index
    chart_data = Stat.new.by_department.sort_by { |k, v| v }.reverse
    @chart     = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:type => 'pie')
      f.series(:name => 'Jobs so far', :data => chart_data.to_a)
      f.title(:text => "Job generation by department")
      #f.plotOptions(:pie=>{:size=>'100%'})
      #f.xAxis(:labels=>{:rotation=>-55 , :align => 'right'},:categories=>chart_data.map{|key,value| key })
    end

    snapshots       = Dbsnap.all
    @open_job_dates = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:type => 'line', :width => 520)
      f.series(:data => snapshots.map(&:open))
      f.xAxis(:labels => { :rotation => -65, :align => 'right' }, :categories => snapshots.map { |i| i.created_at.strftime(format='%D %R') })
      f.title(:text => "Open Jobs by date")
    end

    closed_list = Dbsnap.all.map(&:closed)
    df          = []
    df << closed_list[0]
    (2..closed_list.count-1).each do |d|
      df << closed_list[d] - closed_list[(d - 1)]
      df.compact
    end
    df << closed_list[closed_list.count]

    @closed_job_dates = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:type => 'line', :width => 520)
      f.series(:data => df.compact)
      #f.series(:data=>snapshots.map(&:closed))
      f.xAxis(:labels => { :rotation => -65, :align => 'right' }, :categories => snapshots.map { |i| i.created_at.strftime(format='%D %R') })
      f.title(:text => "Closed Jobs by date")
    end
  end

end
