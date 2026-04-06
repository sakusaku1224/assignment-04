require "csv" # CSVファイルを扱うためのライブラリを読み込んでいます

# ファイル名の入力.csv を付けたパスを返す
def input_file_name(message)
  puts message
  loop do
    file_name = gets.chomp
    #ファイル名が空のまま生成できないようにする
    if file_name.strip.empty?
      puts "ファイル名を入力してください"
    else  
      return "#{file_name}.csv"
    end    
  end
end

# メモ内容を複数行で受け取る
def input_memo_content(message)
  puts message
  puts "完了したら Enterを押してから Ctrl + Dを押します"
  content = readlines.join
  # readlines で Ctrl + D による入力終了を受け取ったあと、
  # 続けて gets を使えるように標準入力を開き直す
  $stdin.reopen("/dev/tty")
  content
end

loop do
  puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
  memo_type = gets.to_i

  if memo_type == 1
    file_path = input_file_name("拡張子を除いたファイル名を入力してください")
    memo_content = input_memo_content("メモしたい内容を入力してください")
    CSV.open(file_path, "w") do |csv|
      memo_content.each_line do |line|
        csv << [line.chomp]
      end
    end
    puts "csvファイルを生成しました!"
    break  

  elsif memo_type == 2
    #フラグ
    success = false
    loop do
      #追記処理
      file_path = input_file_name("編集したいファイル名を入力してください")
      if File.exist?(file_path)
        memo_content = input_memo_content("追記したい内容を入力してください")
        CSV.open(file_path, "a") do |csv|
          memo_content.each_line do |line|
            csv << [line.chomp]
          end            
        end
        puts "csvファイルに追記しました!"
        #成功フラグ
        success = true
        break
      else
        puts "そのファイルは存在しません"
        puts "ファイル名を再入力する場合はEnter、メニューに戻る場合はqを押してください"
        retry_choice = gets.chomp
        if retry_choice == "q"
          break  
        end
      end
    end
    if success
      break
    end 
  else
    puts "1か2を入力してください"
  end
end