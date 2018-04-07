class LocaleSelector < TestCentricity::PageSection
  trait(:section_locator)     { 'div.simplemodal-container.modal-language-pos' }
  trait(:section_name)        { 'Locale selector' }

  # Locale selector UI elements
  buttons  close_button:    'button.modalCloseImg.simplemodal-close',
           change_button:   'button.language-region-change.btn.btn-primary'

  def dismiss
    close_button.click
    self.wait_until_hidden(5)
  end
end
