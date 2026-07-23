# MikroTik як інтернет-шлюз

## Мета

Описати отримання інтернету через TP-Link WDS, NAT для LAN і доступ до керування мостом.

## Архітектура

`ether1-WAN` підключений до LAN-порту TP-Link. MikroTik отримує зовнішню адресу по DHCP, має службову адресу `192.168.0.2/24` і маршрутизує мережу `192.168.100.0/24`.

## Передумови

- TP-Link працює як WDS Bridge;
- DHCP-сервер TP-Link вимкнений;
- `ether1-WAN` не входить до LAN bridge;
- існують interface lists `LAN` і, за потреби, `WAN`;
- збережено export поточної конфігурації MikroTik.

## Конфігурація

DHCP-клієнт і загальний NAT:

```routeros
/ip dhcp-client add interface=ether1-WAN disabled=no
/ip firewall nat add chain=srcnat out-interface=ether1-WAN action=masquerade comment="NAT: LAN to WAN"
```

DNS для локальних клієнтів:

```routeros
/ip dns set allow-remote-requests=yes
```

Forwarding LAN → WAN має стояти перед загальним drop:

```routeros
/ip firewall filter add chain=forward action=accept in-interface-list=LAN out-interface=ether1-WAN comment="FORWARD: allow LAN to WAN"
```

Доступ MikroTik до TP-Link:

```routeros
/ip address add address=192.168.0.2/24 interface=ether1-WAN comment="TP-Link management network"
/ip firewall nat add chain=srcnat dst-address=192.168.0.1 action=src-nat to-addresses=192.168.0.2 place-before=0 comment="SRC-NAT: Access to TP-Link Bridge"
```

Доступ до TP-Link через адресу MikroTik:

```routeros
/ip firewall nat add chain=dstnat dst-address=192.168.100.1 protocol=tcp dst-port=8080 action=dst-nat to-addresses=192.168.0.1 to-ports=80 comment="DST-NAT: TP-Link management"
```

Публікація незашифрованого вебінтерфейсу TP-Link через port forwarding збільшує поверхню атаки. Доступ до `192.168.100.1:8080` слід додатково обмежити дозволеним списком адміністративних адрес.

## Покрокове налаштування

1. Експортувати поточну конфігурацію.
2. Перевірити роль `ether1-WAN`.
3. Додати DHCP-клієнт і перевірити default route.
4. Додати службову адресу для TP-Link.
5. Додати специфічний src-nat перед загальним masquerade.
6. Додати дозволи LAN → WAN перед drop-правилами.
7. За потреби додати обмежений доступ до панелі TP-Link.
8. Перевірити порядок і лічильники правил.

## Перевірка

```routeros
/ip dhcp-client print detail
/ip address print
/ip route print
/ip firewall nat print stats
/ip firewall filter print stats
```

Перевірити DNS і зовнішній доступ з тестової VM, а також доступ до TP-Link лише з адміністративного джерела.

## Troubleshooting

| Симптом | Можлива причина | Рішення |
|---|---|---|
| WAN не отримує адресу | WDS або DHCP недоступні | Перевірити TP-Link, кабель і DHCP client |
| LAN без інтернету | Немає маршруту, NAT або forward | Перевірити route та лічильники правил |
| TP-Link не відкривається | Немає службової адреси або src-nat | Перевірити `192.168.0.2/24` і порядок NAT |
| DNS працює лише на MikroTik | Firewall блокує DNS клієнтів | Перевірити input для TCP/UDP 53 з LAN |

## Пов'язані документи

- [TP-Link WDS Bridge](../../network/tp-link-wds-bridge.md)
- [Безпека MikroTik](../firewall/management-security.md)
- [Адресний план](../../network/addressing/subnets.md)

## Історія змін

| Дата | Автор | Опис зміни |
|---|---|---|
| 2026-07-23 | Команда проєкту | Систематизовано конфігурацію інтернет-шлюзу |
