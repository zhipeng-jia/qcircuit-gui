require 'fileutils'

class LatexController < ApplicationController
  def render_formula
    code = params[:code]
    file_path = Rails.root.join('public', 'latex', 'formula', "#{code}.png").to_s
    FileUtils.mkpath Rails.root.join('public', 'latex', 'formula')
    unless File.exists? file_path
      work_dir = Rails.root.join('tmp', 'latex', SecureRandom.hex(10))
      FileUtils.mkpath work_dir
      File.open(work_dir.join(code + '.tex'), 'w') do |f|
        f.puts '\nonstopmode'
        f.puts '\documentclass[border=1pt]{standalone}'
        f.puts '\usepackage{amsmath,amsfonts,amsthm,amssymb}'
        f.puts '\newcommand{\bra}[1]{{\left\langle{#1}\right\vert}}'
        f.puts '\newcommand{\ket}[1]{{\left\vert{#1}\right\rangle}}'
        f.puts '\begin{document}'
        f.puts "$#{decode_latex_formula(code)}$"
        f.puts '\end{document}'
      end
      exit_status = nil
      Dir.chdir(work_dir) { exit_status = system "pdflatex -shell-escape #{code}.tex" }
      unless exit_status
        FileUtils.rm_r work_dir
        return send_file Rails.root.join('public', 'latex', 'invalid.png'), type: 'image/png', disposition: 'inline'
      end
      Dir.chdir(work_dir) { system "convert -density 1000 #{code}.pdf #{code}.png" }
      FileUtils.cp work_dir.join(code + '.png'), file_path
      FileUtils.rm_r work_dir
    end
    send_file file_path, type: 'image/png', disposition: 'inline'
  end

  private
  def decode_latex_formula(code)
    (0...code.length / 2).map { |i| (code[i * 2] + code[i * 2 + 1]).to_i(16).chr }.join
  end
end
