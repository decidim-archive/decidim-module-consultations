$(document).ready(function () {
  'use strict';

  var endorseDialog = $('#question-endorse-modal'),
      endorseConfirmDialog = $('#question-endorse-confirm-modal'),
      responseButtons = $('.response-title'),
      buttonChange = $('#question-endorse-confirm-modal-button-change'),
      buttonConfirm = $('#question-endorse-confirm-modal-confirm'),
      button = $('#endorse_button');

  if (endorseDialog.length && button.length) {
    button.click(function () {
      endorseDialog.foundation('open');
    });
  }

  if (endorseDialog.length && responseButtons.length && endorseConfirmDialog.length) {
    responseButtons.click(function () {
      $('#question-endorse-confirm-modal-question-title').text($(this).text());
      $('#decidim_consultations_response_id').val($(this).data('response-id'));

      endorseDialog.foundation('close');
      endorseConfirmDialog.foundation('open');
    });
  }

  if (buttonChange.length && endorseDialog.length && endorseConfirmDialog.length) {
    buttonChange.click(function() {
      endorseConfirmDialog.foundation('close');
      endorseDialog.foundation('open');
    });
  }

  $('#confirm-endorsement-form').on("ajax:success", function() {
    endorseConfirmDialog.foundation('close');
  });
});
