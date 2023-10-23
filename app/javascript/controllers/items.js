document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.minus-plus').forEach(function(button) {
    button.addEventListener('click', function() {
      var itemId = this.dataset.itemId;
      var action = this.dataset.action;
      var quantityElement = document.getElementById('quantity_' + itemId);
      var currentQuantity = parseInt(quantityElement.innerText);

      if (action === 'increment') {
        quantityElement.innerText = currentQuantity + 1;
      } else if (action === 'decrement' && currentQuantity > 1) {
        quantityElement.innerText = currentQuantity - 1;
      }
    });
  });
});

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.truncate-text').forEach(function(container) {
    var maxCharacters = container.dataset.maxLength;
    var text = container.querySelector('p').innerText;

    if (text.length > maxCharacters) {
      var truncatedText = text.substring(0, maxCharacters);
      container.querySelector('p').innerHTML = truncatedText + '<span class="ellipsis">...</span>';

      var ellipsis = container.querySelector('.ellipsis');
      ellipsis.addEventListener('click', function() {
        container.querySelector('p').innerText = text;
      });
    }
  });
});
