prawn_document do |pdf|
  pdf.text 'Listando Assuntos'
  pdf.move_down 20
  pdf.table @subjects.collect{|s| [s.id, s.description]}
end