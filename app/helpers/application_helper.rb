module ApplicationHelper
   # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "language Q&A Web!"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def add_dots(text, limit)
    if text.length > limit
      "#{text[0..limit]}..."
    else
      text
    end
  end
end
