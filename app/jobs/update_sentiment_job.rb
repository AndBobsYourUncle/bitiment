# frozen_string_literal: true

require 'rss'

class UpdateSentimentJob < ApplicationJob
  queue_as :update_sentiment

  RSS_FEEDS = [
    'https://news.google.com/news/rss/search/section/q/bitcoin/bitcoin?gl=US&ned=us&hl=en'
  ].freeze

  def perform
    analyzer = Sentimental.new
    analyzer.load_defaults

    total_sentiment = 0

    word_scores = analyzer.word_scores.to_json
    influencers = analyzer.influencers.to_json
    dictionary_hash = Digest::SHA256.hexdigest(word_scores + influencers)
    feed_list_hash = Digest::SHA256.hexdigest(RSS_FEEDS.to_json)

    snapshot = Snapshot.create dictionary_hash: dictionary_hash, feed_list_hash: feed_list_hash

    RSS_FEEDS.each do |feed_url|
      rss = RSS::Parser.parse feed_url, false

      rss.items.each do |item|
        article_sentiment = analyzer.score item.title
        total_sentiment += article_sentiment
        Article.find_or_create_by(title: item.title, published_at: item.pubDate) do |article|
          article.snapshot = snapshot
          article.sentiment = article_sentiment
          article.dictionary_hash = dictionary_hash
        end
      end
    end

    snapshot.update sentiment: total_sentiment
  end
end
