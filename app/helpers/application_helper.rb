module ApplicationHelper
  def dealmaker_options
    return ["Cashbuyer", "Wholesaler", "Rehabber/Flipper", "JV Partner", "Buy and Hold Investor", "Contractor", "Title Agent", "Attorney", "Broker", "Hard Money Lender", "Owner/Developer", "Capital Provider", "Motivated Seller", "Intermediary", "Service Provider", "Contractor", "Architect", "Lender", "Investor", "Property Manager", "Asset Manager"]
  end

  def pageless(total_pages, url=nil, container=nil)
    opts = {
        :totalPages => total_pages,
        :url        => url,
        :loaderMsg  => 'Loading more pages...',
        :loaderImage => image_path('load.gif')
    }

    container && opts[:container] ||= container

    javascript_tag("$('#{container}').pageless(#{opts.to_json});")
  end
end
