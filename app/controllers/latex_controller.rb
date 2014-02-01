require 'fileutils'

class LatexController < ApplicationController
  def render_formula
    code = params[:code]
    file_path = Rails.root.join('public', 'latex', 'formula', "#{code}.png").to_s
    FileUtils.mkpath Rails.root.join('public', 'latex', 'formula')
    unless File.exists? file_path
      work_dir = Rails.root.join('tmp', 'latex')
      FileUtils.mkpath work_dir
      File.open(work_dir.join(code + '.tex'), 'w') do |f|
        f.puts '\documentclass[border=1pt,convert={density=1000}]{standalone}'
        f.puts '\newcommand{\bra}[1]{{\left\langle{#1}\right\vert}}'
        f.puts '\newcommand{\ket}[1]{{\left\vert{#1}\right\rangle}}'
        f.puts '\begin{document}'
        f.puts "$#{decode_latex_formula(code)}$"
        f.puts '\end{document}'
      end
      pdflatex_path = Rails.configuration.latex.pdflatex_path
      Dir.chdir(work_dir) { system "#{pdflatex_path} -shell-escape #{code}.tex" }
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
