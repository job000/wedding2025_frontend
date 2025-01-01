weddingapp_frontend_v2/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   ├── asset_constants.dart
│   │   │   └── theme_constants.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── interceptors/
│   │   │       ├── auth_interceptor.dart
│   │   │       ├── error_interceptor.dart
│   │   │       └── logging_interceptor.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── custom_colors.dart
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       ├── dialog_utils.dart
│   │       ├── navigation_utils.dart
│   │       ├── storage_utils.dart
│   │       ├── validators.dart
│   │       └── extensions/
│   │           ├── context_extensions.dart
│   │           ├── string_extensions.dart
│   │           └── date_extensions.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── auth_response_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── register_screen.dart
│   │   │       └── widgets/
│   │   │           ├── auth_form.dart
│   │   │           └── social_login_buttons.dart
│   │   ├── rsvp/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── rsvp_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── rsvp_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── rsvp_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── rsvp.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── rsvp_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── create_rsvp_usecase.dart
│   │   │   │       └── get_rsvps_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── rsvp_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── rsvp_form_screen.dart
│   │   │       │   └── rsvp_list_screen.dart
│   │   │       └── widgets/
│   │   │           ├── rsvp_form.dart
│   │   │           └── rsvp_card.dart
│   │   ├── gallery/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── gallery_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── media_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── gallery_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── media.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── gallery_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── upload_media_usecase.dart
│   │   │   │       └── get_gallery_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── gallery_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── gallery_screen.dart
│   │   │       │   └── upload_media_screen.dart
│   │   │       └── widgets/
│   │   │           ├── media_grid.dart
│   │   │           └── media_upload_form.dart
│   │   ├── info/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── info_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── info_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── info_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── info.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── info_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── create_info_usecase.dart
│   │   │   │       └── get_info_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── info_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── info_screen.dart
│   │   │       │   └── create_info_screen.dart
│   │   │       └── widgets/
│   │   │           ├── info_card.dart
│   │   │           └── info_form.dart
│   │   └── faq/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── faq_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   └── faq_model.dart
│   │       │   └── repositories/
│   │       │       └── faq_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── faq.dart
│   │       │   ├── repositories/
│   │       │   │   └── faq_repository.dart
│   │       │   └── usecases/
│   │       │       ├── create_faq_usecase.dart
│   │       │       └── get_faqs_usecase.dart
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── faq_provider.dart
│   │           ├── screens/
│   │           │   ├── faq_screen.dart
│   │           │   └── create_faq_screen.dart
│   │           └── widgets/
│   │               ├── faq_card.dart
│   │               └── faq_form.dart
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── animated_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── custom_app_bar.dart
│   │   │   └── custom_bottom_nav.dart
│   │   └── models/
│   │       ├── api_response.dart
│   │       └── base_model.dart
│   └── main.dart
├── test/
│   ├── core/
│   │   ├── network/
│   │   │   └── api_client_test.dart
│   │   └── utils/
│   │       └── validators_test.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_test.dart
│   │   │   └── presentation/
│   │   │       └── providers/
│   │   │           └── auth_provider_test.dart
│   │   └── rsvp/
│   │       ├── data/
│   │       │   └── repositories/
│   │       │       └── rsvp_repository_test.dart
│   │       └── presentation/
│   │           └── providers/
│   │               └── rsvp_provider_test.dart
│   └── widget_test.dart
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── background.jpg
│   │   └── placeholder.png
│   ├── fonts/
│   │   ├── Montserrat-Regular.ttf
│   │   ├── Montserrat-Bold.ttf
│   │   └── Montserrat-Light.ttf
│   └── animations/
│       ├── loading.json
│       └── success.json
├── .gitignore
├── analysis_options.yaml
├── Dockerfile
├── docker-compose.yml
└── pubspec.yaml

## Commands for docker test:
# Naviger til frontend-mappen
cd ../weddingapp_frontend_v2

# Bygg Docker image
docker-compose build

# Start frontend container
docker-compose up -d

# Verifiser at containeren kjører
docker-compose ps