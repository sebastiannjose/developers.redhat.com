require_relative 'abstract/site_base'

# this is the page class that contains all elements and common methods related to the Downloads page
class DownloadsPage < SiteBase
  page_url('/downloads/')
  expected_element(:h2, text: 'Downloads')
  # page_title('Downloads | Red Hat Developers')

  element(:loading_spinner)                { |b| b.element(css: '#downloads .fa-refresh') }
  element(:most_popular_section)           { |b| b.div(class: 'most-popular-downloads') }
  elements(:download_buttons)              { |b| b.buttons(css: '#downloads .fa-download') }
  elements(:most_popular_download_buttons) { |b| b.buttons(css: '.most-popular-downloads .fa-download') }
  elements(:product_downloads)             { |b| b.divs(css: '#downloads h5') }

  value(:most_popular_downloads)           { |p| p.most_popular_section.text }
  value(:most_popular_downloads_btns)      { |p| p.most_popular_download_buttons.size }
  value(:download_btns)                    { |p| p.download_buttons.size }

  def wait_until_loaded
    wait_for_ajax && loading_spinner.wait_while(&:present?)
  end

  def available_downloads
    products = []
    product_downloads.each do |product|
      products << product.text
    end
    products
  end

  def click_to_download(url)
    myelement = @browser.element(xpath: "//*[@id='downloads']//a[@href='#{url}']")
    myelement.fire_event('click')
  end

  def download_buttons_linked_to_dm(url)
    @browser.element(xpath: "//*[@id='downloads']//a[@href='#{url}']").present?
  end

end
