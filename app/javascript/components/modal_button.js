const modalButtons = () => {
  var modal = document.querySelector('.modal');

  var showModal = document.querySelector('.show-modal');
  var closeModal = document.querySelectorAll('.close-modal');

  showModal.addEventListener('click', function () {
    modal.classList.toggle('hidden')
  });

  closeModal.forEach(close => {
    close.addEventListener('click', function () {
      modal.classList.toggle('hidden')
    });
  });

  const updateResultsList = (event) => {
    event.preventDefault();
    list.innerHTML = '';
    const input = document.querySelector('#search-input');
    fetchMovies(input.value);
  }
}
export { modalButtons };
