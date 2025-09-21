class Posting < ApplicationRecord

  # set belongs_to, but other side without has_many
  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'

  # naming of method not the best possible, it's confusing.
  def article_with_image
    # strange return, I'm expecting return article, not type
    # For a cleaner solution we could use regex and return result or nil
    return type if type != 'Article'

    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    # strange return not expecting type (one of the minuses not strong typed languages)
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + 9]
    # and so on
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      unless data.nil?
        tag_attributes[attribute] = data[1] unless data.size < 2
      end
    end
    # tag_parse
    tag_attributes
  end
end
