require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    profiles = Nokogiri::HTML(html)
    counter = 1
    profiles_hash = []

    profiles.css('div.student-card').each_with_index do |project, idx|

      student = project.css("h4.student-name").text
      location = project.css("p.student-location").text
      profile_url = project.css("a")[0]['href']

        profiles_hash << {
          :name => student,
          :location => location,
          :profile_url => profile_url
          # "./fixtures/student-site/#{profile_url}"
        }
      counter += 1

    end
    profiles_hash


  end

  # students: profiles.css("div.student-card")
  # names: profiles.css("h4.student-name").text
  # location: profiles.css( "p.student-location").text || profiles.css("p.student-location")[1].text
  # profile_url profiles.css("a")[1]['href'] need index??

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    info = Nokogiri::HTML(html)
    output = {}
    social = info.css("div.social-icon-container a").map{|link| link.attribute("href").value}

      social.each do |url|
        if url.include?("linkedin")
          output[:linkedin] = url
        elsif url.include?("twitter")
          output[:twitter] = url
        elsif url.include?("github")
          output[:github] = url
        else
          output[:blog] = url
        end
      end


    output[:profile_quote] = info.css("div.vitals-text-container div.profile-quote").text

    output[:bio] = info.css("div.details-container p").text
    output
  end

end
#info.css("div.social-icon-container").map{|value| puts value}
# twitter: profiles.css("div.student-card")
# linkedin: profiles.css("h4.student-name").text
# github: profiles.css( "p.student-location").text ||
# blog profile_url: profiles.css("a")[1]['href'] need index??
# profile_quote:
# bio
