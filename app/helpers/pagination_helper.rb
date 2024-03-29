# frozen_string_literal: true

module PaginationHelper
  def self.paginate(scope:, page:, limit:)
    page = page.to_i.zero? ? 1 : page.to_i
    limit = limit.to_i.zero? ? 10 : limit.to_i
    offset = (page - 1) * limit
    scoped = scope.offset(offset).limit(limit)
    previous_page = page > 1 ? page - 1 : nil
    next_page = scoped.size == limit ? page + 1 : nil

    {
      items: scoped,
      pagination: {
        current_page: page,
        previous_page:,
        next_page:,
        total_pages: (scope.size.to_f / limit).ceil,
        total_count: scope.size
      }
    }
  end
end
