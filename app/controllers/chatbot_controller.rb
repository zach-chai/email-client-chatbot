class ChatbotController < ApplicationController

  FETCH_TOKENS = ['fetch', 'get', 'find', 'open', 'show', 'view', 'tell', 'give', 'read']
  EMAIL_TYPES = ['unread', 'recent', 'today', 'yesterday', 'morning', 'afternoon', 'evening']

  FETCH_SETS = [
    [['what'], ['emails'], EMAIL_TYPES],
    [['you'], ['have'], ['emails']],
    [FETCH_TOKENS, ['emails'], EMAIL_TYPES],
    [FETCH_TOKENS, EMAIL_TYPES, ['emails']]
  ]
  #TODO detect if email address and fetch those emails

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    msg = params[:message] || 'Hello user'
    msg = Textoken(msg.downcase).tokens

    # @res = parse_rules msg
    @res = parse_sets msg
    # @res = "#{@res}: #{ordered_tokens_heuristic(msg, [FETCH_TOKENS, EMAIL_TYPES])}"

    @res
  end

  def test

  end

  private


  def parse_rules(msg)
    if msg.include? 'help'
      'help'
    elsif ordered_tokens_exist? msg, [FETCH_TOKENS, EMAIL_TYPES]
      "fetch emails ordered_tokens"
    elsif include_any? msg, FETCH_TOKENS
      if email_type = include_any?(msg, EMAIL_TYPES)
        "fetch emails #{email_type}"
      else
        "fetch emails default"
      end
    else
      msg
    end
  end

  def parse_sets(msg)
    counter = 0
    FETCH_SETS.each do |fetch_set|
      if matches = ordered_tokens_exist?(msg, fetch_set)
        return "fetch set #{counter} with matches #{matches}"
      else
        counter += 1
      end
    end
    msg
  end

  def include_any?(msg, tokens)
    tokens.each do |token|
      if msg.include? token
        return token
      end
    end
    false
  end

  def ordered_tokens_exist?(msg, tokens, strict = false)
    matches = []
    if strict
      msg.each do |msg_token|
        temp_tokens = tokens.clone
        byebug
        if temp_tokens.first.include? msg_token
          temp_tokens.shift
          matches << msg_token
        end
        if temp_tokens.empty?
          matches
        end
      end
      false
    else
      tokens.each do |token_array|
        if token_array.include? msg.first
          matches << msg.shift
        end
      end
      if matches.empty?
        false
      else
        matches
      end
    end
  end

  def ordered_tokens_heuristic(msg, tokens, opts = {})
    tokens_length = tokens.length
    msg.each do |msg_token|
      if tokens.first.include? msg_token
        tokens = tokens.delete(0)
      end
      if tokens.nil?
        tokens = []
        break
      end
    end
    (tokens_length - tokens.length).to_f / tokens_length.to_f
  end
end
