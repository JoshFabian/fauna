namespace :plans do

  desc "Create plans"
  task :create => :environment do
    puts "#{Time.now}: importing plans"
    objects = [{'name' => "Buy 1 Listing Credit", 'amount' => 500, 'credits' => 1, 'subscription' => false},
               {'name' => "Buy 5 Listing Credits", 'amount' => 2000, 'credits' => 5, 'subscription' => false},
               {'name' => "Buy 10 Listing Credits", 'amount' => 3000, 'credits' => 10, 'subscription' => false}]
    objects.each do |hash|
      puts "#{Time.now}: hash:#{hash}"
      Plan.create(hash)
    end
    objects = [{'name' => "Monthly - $39/month", 'amount' => 3900, 'subscription' => true, 'interval' => 'month',
                'interval_count' => 1},
               {'name' => "Yearly - $29/monnth", 'amount' => 34800, 'subscription' => true, 'interval' => 'year',
                'interval_count' => 1}]
    objects.each do |hash|
      puts "#{Time.now}: hash:#{hash}"
      Plan.create(hash)
    end
    puts "#{Time.now}: completed"
  end

  desc "Export plans to stripe"
  task :export => :environment do
    puts "#{Time.now}: exporting plans"
    Plan.active.where(subscription: true).each do |plan|
      begin
        Stripe::Plan.create(amount: plan.amount, id: plan.stripe_id, interval: plan.interval, name: plan.name,
          currency: plan.currency)
      rescue Exception => e
        puts "#{Time.now}: [error] #{e.message}"
      end
    end
    puts "#{Time.now}: completed"
  end

end