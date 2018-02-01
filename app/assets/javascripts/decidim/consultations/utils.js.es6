/* eslint-disable no-invalid-this */

(() => {
  $(".endorse-button-caption").mouseover(function () {
    const replaceText = $(this).data('replace');

    if (replaceText !== null && replaceText !== undefined && replaceText !== "") {
        $(this).text(replaceText);
    }
  });

  $(".endorse-button-caption").mouseout(function () {
    const originalText = $(this).data('original');

    if (originalText !== null && originalText !== undefined && originalText !== "") {
        $(this).text(originalText);
    }
  });
})(this);
