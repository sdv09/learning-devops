### Домашнее задание к занятию 1. «Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения» [Степанников Денис]

---

### Задача 1
Опишите кратко, в чём основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

### Решение:

**Полная (аппаратная) виртуализация** создает специальный уровень абстракции между аппаратными ресурсами и гостевыми операционными системами. Гостевые операционные системы не осведомлены о существовании гипервизора и взаимодействуют с аппаратными ресурсами через слой абстракции гипервизора. Несмотря на преимущество полной изоляции между гостевыми виртуальными машинами, этот подход сопровождается дополнительными накладными расходами из-за слоя абстракции.

**Паравиртуализация** предполагает, что гостевые операционные системы осведомлены о виртуальной среде и способны взаимодействовать с ней. Например, для Windows требуются специальные драйверы, а для Linux - поддержка со стороны ядра. В паравиртуализации гостевые операционные системы могут обращаться к аппаратным ресурсам напрямую, минуя слой абстракции, что может повысить производительность, но влечет снижение изоляции между виртуальными машинами.

**Виртуализация на основе операционной системы** происходит на уровне самой операционной системы, а не на прямом уровне аппаратного обеспечения. Обычно это относится к контейнерной виртуализации, где контейнеры используют ядро хост-операционной системы, но при этом изолированы друг от друга. Этот тип виртуализации характеризуется более низкими накладными расходами по сравнению с полной и паравиртуализацией, но обеспечивает наименьший уровень изоляции между контейнерами.

### Задача 2
Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.

Организация серверов:

- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:

1. высоконагруженная база данных, чувствительная к отказу;
2. различные web-приложения;
3. Windows-системы для использования бухгалтерским отделом;
4. системы, выполняющие высокопроизводительные расчёты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

### Решение:
1. высоконагруженная база данных, чувствительная к отказу:

Предлагается использовать физические серверы для создания отказоустойчивого кластера системы управления базами данных (СУБД). Это обосновано тем, что высокая нагрузка на СУБД обеспечит эффективное использование ресурсов физических серверов. В данном случае виртуализация не приносит дополнительных преимуществ, так как высокая загрузка СУБД не позволяет полностью использовать плюсы виртуализации, такие как повышенная утилизация аппаратных ресурсов. Отсутствие слоя виртуализации также обеспечит максимальную производительность.

Тем не менее, стоит отметить, что виртуализация (при наличии аппаратной виртуализации, хотя она не указана в доступных вариантах) является широко используемым методом для развертывания нагруженных кластеров СУБД из-за удобства управления виртуальными машинами по сравнению с физическими серверами.

2. различные web-приложения:

Использование виртуализации на уровне операционной системы, особенно при работе с собственно разработанными приложениями, становится стандартом при контейнеризации. В случае использования готовых решений, которые не предоставляются в форме контейнеров, предпочтительными вариантами являются полная или паравиртуализация.

3. Windows-системы для использования бухгалтерским отделом:

Для систем с ограниченной и средней нагрузкой рекомендуется использовать паравиртуализацию (лично я бы предпочел аппаратную виртуализацию). Cоздаем набор виртуальных машин на базе Windows и устанавливаем на них финансовую систему. В случае высоконагруженных систем, особенно на основе 1С, часто рекомендуется использовать физические серверы, поскольку слой виртуализации может значительно влиять на производительность 1С.

4. системы, выполняющие высокопроизводительные расчёты на GPU:

Больше выгоды можно извлечь из физических серверов. Основная идея заключается в том, что для максимальной эффективности работы с аппаратным обеспечением, особенно при вычислениях на графических процессорах (GPU), рекомендуется минимизировать дополнительные расходы, которые могут возникнуть при использовании виртуализации. При этом не исключено применение паравиртуализации, и окончательное решение будет зависеть от конкретных требований задачи.

### Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
2. Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

### Решение:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий:

Bare-metal гипервизор (полная виртуализация) основанный на VMware vCenter/VMware ESXi. Среди преимуществ можно выделить эффективное использование аппаратных ресурсов серверов и отличную совместимость как с операционными системами Windows, так и с Linux для гостевых ОС. Существует множество давно проверенных и относительно простых в использовании решений для резервного копирования. Недостатком является, что решение бесплатное.

2. Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

Использование KVM в режиме паравиртуализации. KVM отлично интегрируется с операционной системой Linux на уровне гостевых ОС и потенциальное преимущество режима паравиртуализации заключается в возможности достижения более высокой производительности по сравнению с полной виртуализацией.

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.

Я предлагаю использовать Microsoft Hyper-V. Поскольку и Windows, и Hyper-V являются продуктами Microsoft, это обеспечит максимальную совместимость между гипервизором и гостевой операционной системой. Hyper-V поддерживает оба режима виртуализации: полную (аппаратную) виртуализацию ("Hyper-V Hypervisor") и паравиртуализацию ("Hyper-V Enlightenments"). Возможно, режим паравиртуализации может привести к увеличению производительности, поэтому конкретный выбор режима лучше всего сделать на основе результатов практических тестов.

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

VirtualBox представляет собой легкий и бесплатный инструмент для виртуализации, который поддерживается на всех основных операционных системах.

### Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

### Решение:

Несмотря на одинаковость общих принципов, детали функционирования различных виртуализационных платформ могут существенно различаться, требуя экспертизы по каждой из них для успешной поддержки таких гетерогенных установок. Это значительно увеличивает затраты на обслуживание и общую сложность ИТ-инфраструктуры. В то время как совмещение различных типов виртуализации широко используется на практике, например, с использованием VMware vCenter для полной виртуализации и контейнера containerd для виртуализации на уровне операционной системы, стоит отметить, что, если использование различных платформ виртуализации обусловлено бизнес-потребностями, такие потребности следует удовлетворять, строя гетерогенные решения. Для минимизации рисков и проблем предлагается стандартизировать выбор платформы виртуализации для каждого типа. Например, установить стандартное использование VMware ESXi для аппаратной виртуализации и containerd для виртуализации на уровне операционной системы. Это способствовало бы сокращению сложности и затрат на поддержку виртуализационного ландшафта, избегая излишней разнородности.