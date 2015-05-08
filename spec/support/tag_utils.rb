RSpec::Matchers.define_negated_matcher :not_contain, :include

def tag_lists_for(feed_items, context)
  feed_items.map{ |fi| fi.all_tags_list_on(context) }
end
