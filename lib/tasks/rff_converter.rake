namespace :rff_converter do
    desc "Cleans up all data from db"
    task :total_cleanup => :environment do
        Conversion.all.each do |c|
            c.destroy!
        end
        Key.all.each do |k|
            k.destroy!
        end
    end
end
