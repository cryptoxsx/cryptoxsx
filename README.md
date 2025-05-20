<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Онлайн-ассистент для регистрации</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/@tailwindcss/browser@latest"></script>
    <style>
        /* Стили для адаптивного чат-контейнера */
        .chat-container {
            max-width: 500px;
            margin: 20px auto;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            height: 500px; /* Фиксированная высота контейнера */
            font-family: 'Inter', sans-serif;
            position: relative; /* Добавляем позиционирование для абсолютного позиционирования кнопки */
        }

        .chat-header {
            background-color: #f0f4f8;
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Inter', sans-serif;
        }

        .chat-messages {
            flex-grow: 1;
            padding: 1rem;
            overflow-y: auto; /* Добавляем полосу прокрутки */
            display: flex;
            flex-direction: column;
            font-family: 'Inter', sans-serif;
        }

        .message {
            margin-bottom: 0.75rem;
            display: flex;
            flex-direction: column;
            font-family: 'Inter', sans-serif;
        }

        .message-content {
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            max-width: 85%;
            font-family: 'Inter', sans-serif;
        }

        .sent {
            align-self: flex-end;
            background-color: #dcf8c6;
            color: #1e293b;
            border-bottom-right-radius: 0;
            font-family: 'Inter', sans-serif;
        }

        .received {
            align-self: flex-start;
            background-color: #f0f4f8;
            color: #1e293b;
            border-bottom-left-radius: 0;
            font-family: 'Inter', sans-serif;
        }

        .message-timestamp {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 0.25rem;
            align-self: flex-end;
            font-family: 'Inter', sans-serif;
        }

        .chat-input {
            padding: 1rem;
            border-top: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            font-family: 'Inter', sans-serif;
        }

        .input-field {
            flex-grow: 1;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 0.75rem;
            margin-right: 0.75rem;
            font-size: 1rem;
            outline: none;
            font-family: 'Inter', sans-serif;
        }

        .input-field:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
            font-family: 'Inter', sans-serif;
        }

        .send-button {
            background-color: #0078D7; /* Цвет кнопки ID */
            color: #ffffff;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
            border: none;
            display: flex;
            align-items: center;
            font-family: 'Inter', sans-serif;
        }

        .send-button:hover {
            background-color: #005a9e; /* Более темный синий при наведении */
            font-family: 'Inter', sans-serif;
        }

        .send-button-icon {
            margin-right: 0.5rem;
            height: 1rem;
            width: 1rem;
        }

        @media (max-width: 640px) {
            .chat-container {
                margin: 1rem;
                max-width: 100%;
            }
            .input-field {
                margin-right: 0.5rem;
            }
            .send-button {
                padding: 0.75rem 1rem;
            }
        }

        /* Добавляем стили для индикатора онлайн-статуса */
        .online-indicator {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 50%;
            background-color: #6ee7b7;
            margin-right: 0.5rem;
            display: inline-block;
        }

        .offline-indicator {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 50%;
            background-color: #f94144;
            margin-right: 0.5rem;
            display: inline-block;
        }

        /* Стили для кнопки "Получить Газпром Бизнес ID" */
        #get-gb-id-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #0078D7; /* Цвет компании Газпром нефть */
            color: #ffffff;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem; /* Изменяем на закругленные углы */
            font-size: 1rem;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease-in-out, background-color 0.3s ease;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            width: auto; /* Убираем фиксированную ширину */
            height: auto; /* Убираем фиксированную высоту */
            border: none;
            white-space: nowrap; /* Добавляем, чтобы текст не переносился */
            padding: 0.75rem 1rem; /* Немного уменьшаем вертикальный padding */
        }

        #get-gb-id-button:hover {
            background-color: #005a9e; /* Более темный синий при наведении */
            transform: scale(1.1);
        }

        /* Стили для всплывающего уведомления */
        #gb-id-tooltip {
            position: absolute;
            bottom: calc(100% + 10px);
            right: 0;
            background-color: #333333;
            color: #ffffff;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            transform: translateY(-10px);
            z-index: 1001;
        }

        #get-gb-id-button:hover + #gb-id-tooltip {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .tooltip-arrow {
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #333333 transparent transparent transparent;
            transform: translateY(-1px);
        }

    </style>
</head>
<body class="bg-gray-100 font-sans antialiased">
    <button id="get-gb-id-button">
        <b style="font-weight: bold;">Получить ID</b>
        <div id="gb-id-tooltip">
            Получить Газпром Бизнес ID
            <div class="tooltip-arrow"></div>
        </div>
    </button>
    <div class="chat-container" style="display: none;">
        <div class="chat-header">
            <span class="online-indicator"></span>Онлайн-консультант Костик
        </div>
        <div class="chat-messages" id="chat-messages">
            </div>
        <div class="chat-input">
            <input type="text" id="input-field" class="input-field" placeholder="Введите ваш вопрос...">
            <button id="send-button" class="send-button">
                Отправить
            </button>
        </div>

    </div>

    <script>
        const chatContainer = document.querySelector('.chat-container');
        const chatMessages = document.getElementById('chat-messages');
        const inputField = document.getElementById('input-field');
        const sendButton = document.getElementById('send-button');
        const getGbIdButton = document.getElementById('get-gb-id-button');
        const registrationSteps = [
            "Добрый день! Я помогу вам пройти процесс регистрации в системе Газпром Бизнес ID",
            "Укажите ИНН организации",
            "Укажите КПП организации",
            "Введите вашу фамилию",
            "Введите ваше имя",
            "Укажите номер телефона",
            "Укажите адрес электронной почты",
            "Отлично! Теперь придумайте пароль. Он должен быть не менее 8 символов",
            "Пожалуйста, подтвердите ваш пароль",
            "Спасибо за предоставленную информацию! Для завершения процедуры регистрации подтвердите адрес электронной почты",
            "Остались вопросы? Направьте обращение в техническую поддержку по адресу bidsupport@gazprom-neft.ru"
        ];
        let currentStep = 0;
        let userINN = "";
        let userKPP = "";
        let userEmail = "";
        let userPassword = "";
        let userName = "";
        let userSurname = "";
        let userPhone = "";
        let chatVisible = false; // Добавляем переменную для отслеживания видимости чата
        let savedMessages = []; // Массив для хранения сообщений
        let isFirstOpening = true;
        let initialMessageShown = false; // Добавляем флаг для отслеживания показа первого сообщения

        function addMessage(text, type) {
            const message = document.createElement('div');
            message.classList.add('message');
            const messageContent = document.createElement('div');
            messageContent.classList.add('message-content', type);
            messageContent.textContent = text;
            const timestamp = document.createElement('div');
            timestamp.classList.add('message-timestamp');
            const now = new Date();
            const hours = now.getHours().toString().padStart(2, '0');
            const minutes = now.getMinutes().toString().padStart(2, '0');
            timestamp.textContent = `${hours}:${minutes}`;
            message.appendChild(messageContent);
            message.appendChild(timestamp);
            chatMessages.appendChild(message);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            savedMessages.push({ text, type, timestamp: `${hours}:${minutes}` }); // Сохраняем сообщение с временем
        }

        function validateEmail(email) {
            const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

        function validatePassword(password) {
            return password.length >= 8;
        }

        function validateINN(inn) {
            return /^\d{10}$/.test(inn);
        }

        function validateKPP(kpp) {
            return /^\d{9}$/.test(kpp);
        }

        function validateName(name) {
            return /^[а-яА-Я]+$/.test(name);
        }

        function validatePhone(phone) {
            return /^\+7\d{10}$/.test(phone);
        }

        function nextStep(userInput) {
            switch (currentStep) {
                case 1:
                    if (validateINN(userInput)) {
                        userINN = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage(userInput, 'sent');
                        addMessage("ИНН должен содержать 10 цифр", 'received');
                    }
                    break;
                case 2:
                    if (validateKPP(userInput)) {
                        userKPP = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage(userInput, 'sent');
                        addMessage("КПП должен содержать 9 цифр", 'received');
                    }
                    break;
                case 3:
                    if (validateName(userInput)) {
                        userSurname = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage(userInput, 'sent');
                        addMessage("Фамилия должна содержать только буквы (кириллица)", 'received');
                    }
                    break;
                case 4:
                    if (validateName(userInput)) {
                        userName = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage(userInput, 'sent');
                        addMessage("Имя должно содержать только буквы (кириллица)", 'received');
                    }
                    break;
                case 5:
                    if (validatePhone(userInput)) {
                        userPhone = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage(userInput, 'sent');
                        addMessage("Номер телефона должен начинаться с +7 и содержать 11 цифр, например: +79998887766", 'received');
                    }
                    break;
                case 6:
                    if (validateEmail(userInput)) {
                        userEmail = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage("Пожалуйста, введите корректный адрес электронной почты", 'received');
                    }
                    break;
                case 7:
                    if (validatePassword(userInput)) {
                        userPassword = userInput;
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage("Пароль должен быть не менее 8 символов", 'received');
                    }
                    break;
                case 8:
                    if (userInput === userPassword) {
                        addMessage(userInput, 'sent');
                        addMessage(registrationSteps[currentStep + 1], 'received');
                        currentStep++;
                    } else {
                        addMessage("Пароли не совпадают. Попробуйте еще раз", 'received');
                    }
                    break;
                 case 9:
                    addMessage(userInput, 'sent');
                    addMessage(`Мы направили письмо для подтверждения на ваш почтовый ящик ${userEmail}`, 'received');
                    currentStep++;
                    break;
                case 10:
                    addMessage(userInput, 'sent');
                    addMessage(registrationSteps[currentStep], 'received');
                    inputField.disabled = true;
                    sendButton.disabled = true;
                    break;
                default:
                    addMessage("Извините, произошла ошибка.", 'received');
            }
            inputField.value = '';
        }

        // Обработчик клика для кнопки "Получить Газпром Бизнес ID"
        getGbIdButton.addEventListener('click', () => {
            if (chatVisible) {
                chatContainer.style.display = 'none'; // Скрываем контейнер чата
                chatVisible = false; // Устанавливаем флаг в false
            } else {
                chatContainer.style.display = 'flex'; // Показываем контейнер чата
                // Восстанавливаем состояние чата
                chatMessages.innerHTML = ''; // Очищаем сообщения
                if (isFirstOpening) {
                    addMessage(registrationSteps[0], 'received'); // Выводим первое сообщение
                    setTimeout(() => {
                        addMessage(registrationSteps[1], 'received');
                        currentStep = 1;
                    }, 3000);
                    isFirstOpening = false;
                    initialMessageShown = true; // Устанавливаем флаг, что сообщение показано

                } else {
                    savedMessages.forEach(message => { // Выводим сохраненные сообщения
                        const messageDiv = document.createElement('div');
                        messageDiv.classList.add('message');
                        const messageContentDiv = document.createElement('div');
                        messageContentDiv.classList.add('message-content', message.type);
                        messageContentDiv.textContent = message.text;
                        const timestampDiv = document.createElement('div');
                        timestampDiv.classList.add('message-timestamp');
                        timestampDiv.textContent = message.timestamp;
                        messageDiv.appendChild(messageContentDiv);
                        messageDiv.appendChild(timestampDiv);
                        chatMessages.appendChild(messageDiv);
                    });
                }

                if (currentStep < registrationSteps.length) {
                    inputField.disabled = false;
                    sendButton.disabled = false;
                    inputField.focus();
                } else {
                    inputField.disabled = true;
                    sendButton.disabled = true;
                }
                chatVisible = true; // Устанавливаем флаг в true
            }
        });

        // Обработчик клика для кнопки "Отправить"
        sendButton.addEventListener('click', () => {
            const userInput = inputField.value;
            if (userInput.trim() !== "") {
                nextStep(userInput);
            } else {
                addMessage("Пожалуйста, введите сообщение.", 'received');
            }
        });

        // Обработчик нажатия клавиши Enter в поле ввода
        inputField.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                sendButton.click(); // Вызываем клик на кнопке "Отправить"
            }
        });

        // Скрываем контейнер чата при загрузке страницы
        chatContainer.style.display = 'none';
    </script>
</body>
</html>
