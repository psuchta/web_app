import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

export default class extends Controller {
  static targets = ['commentsModal', 'commentsLoading', 'commentsError', 'tagsDiv'];

  static values = {
    videId: String,
  };

  connect() {
  }

  loadComments(event) {
    this.toggleModal();
    axios.get('video_comments', {
      params: {
        video_id: event.params.videoId,
      },
      headers: { Accept: 'application/json' }
    })
      .then((response) => {
        this.commentsLoadingTarget.classList.add('hidden');

        Array.from(response.data).forEach((element) => {
          this.commentsModalTarget.innerHTML += this.make_html_element(element);
        });
      })
      .catch((error) => {
        console.log(error);
        this.commentsLoadingTarget.classList.add('hidden');
        this.commentsErrorTarget.classList.remove('hidden');
      });
  }

  showAllTags(event) {
    const tagsDiv = document.getElementById(`tag_${event.params.videoId}`);
    const invisibleTags = tagsDiv.querySelectorAll('.additional-tag');

    tagsDiv.querySelector('.show-more-tags').classList.add('hidden');
    tagsDiv.querySelector('.show-less-tags').classList.remove('hidden');

    invisibleTags.forEach((arrayItem) => {
      arrayItem.classList.remove('hidden');
    });
  }

  showLessTags(event) {
    const tagsDiv = document.getElementById(`tag_${event.params.videoId}`);
    const invisibleTags = tagsDiv.querySelectorAll('.additional-tag');

    tagsDiv.querySelector('.show-more-tags').classList.remove('hidden');
    tagsDiv.querySelector('.show-less-tags').classList.add('hidden');

    invisibleTags.forEach((arrayItem) => {
      arrayItem.classList.add('hidden');
    });
  }

  make_html_element(element) {
    const options = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric'
    };

    const date = new Date(element.published_at).toLocaleString('en-US', options);

    const html = `<div class="p-4 min-w-full">
                <div class="flex border-2 rounded-lg border-gray-200 border-opacity-50 p-8 sm:flex-row flex-col">
                  <div class="w-10 h-10 sm:mr-8 sm:mb-0 mb-4 inline-flex items-center justify-center rounded-full bg-indigo-100 text-indigo-500 flex-shrink-0">
                    <img class="w-15 h-15 rounded-full" src="${element.author_profile_image_url}">
                  </div>
                  <div class="flex-grow">
                    <a class="mb-3 text-indigo-500 inline-flex items-center">${date}
                    </a>
                    <h2 class="text-gray-900 text-lg title-font font-medium mb-3">${element.author_display_name}</h2>
                    <p class="leading-relaxed text-base">${element.text_display}</p>
                  </div>
                </div>
              </div>`;
    return html;
  }

  toggleModal() {
    this.commentsModalTarget.innerHTML = '';
    this.commentsLoadingTarget.classList.remove('hidden');
    this.commentsErrorTarget.classList.add('hidden');

    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  }
}
