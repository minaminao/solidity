.. index:: ! contract;interface, ! interface contract

.. _interfaces:

**********
Interfaces
**********

.. Interfaces are similar to abstract contracts, but they cannot have any functions implemented.
.. There are further restrictions:

インターフェイスは、抽象的なコントラクトと似ていますが、いかなる機能も実装することはできません。さらに制限があります。

.. - They cannot inherit from other contracts, but they can inherit from other interfaces.

- 他のコントラクトを継承することはできませんが、他のインターフェースを継承することができます。

.. - All declared functions must be external.

- 宣言された機能はすべて外付けでなければなりません。

.. - They cannot declare a constructor.

- コンストラクタを宣言することはできません。

.. - They cannot declare state variables.

- 状態変数を宣言することはできません。

.. - They cannot declare modifiers.

- 修飾を宣言することはできない。

.. Some of these restrictions might be lifted in the future.

これらの制限の一部は、将来的に解除される可能性があります。

.. Interfaces are basically limited to what the Contract ABI can represent, and the conversion between the ABI and
.. an interface should be possible without any information loss.

インターフェイスは基本的にコントラクトABIが表現できる内容に限定されており、ABIとインターフェイスの間の変換は情報を失うことなく可能でなければなりません。

.. Interfaces are denoted by their own keyword:

インターフェイスは、それぞれのキーワードで示されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    interface Token {
        enum TokenType { Fungible, NonFungible }
        struct Coin { string obverse; string reverse; }
        function transfer(address recipient, uint amount) external;
    }

.. Contracts can inherit interfaces as they would inherit other contracts.

コントラクトは、他のコントラクトを継承するように、インターフェースを継承することができます。

.. All functions declared in interfaces are implicitly ``virtual`` and any
.. functions that override them do not need the ``override`` keyword.
.. This does not automatically mean that an overriding function can be overridden again -
.. this is only possible if the overriding function is marked ``virtual``.

インターフェースで宣言されたすべての関数は暗黙のうちに ``virtual`` となり、それをオーバーライドする関数には ``override`` キーワードは必要ありません。これは、オーバーライドされた関数が再びオーバーライドできることを自動的に意味するものではありません - これは、オーバーライドされた関数が ``virtual`` とマークされている場合にのみ可能です。

.. Interfaces can inherit from other interfaces. This has the same rules as normal
.. inheritance.

インターフェイスは、他のインターフェイスを継承することができます。これには通常の継承と同じルールがあります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    interface ParentA {
        function test() external returns (uint256);
    }

    interface ParentB {
        function test() external returns (uint256);
    }

    interface SubInterface is ParentA, ParentB {
        // Must redefine test in order to assert that the parent
        // meanings are compatible.
        function test() external override(ParentA, ParentB) returns (uint256);
    }

.. Types defined inside interfaces and other contract-like structures
.. can be accessed from other contracts: ``Token.TokenType`` or ``Token.Coin``.

インターフェースや他のコントラクトに似た構造の中で定義されたタイプは、他のコントラクトからアクセスすることができます。 ``Token.TokenType`` または ``Token.Coin`` 。

.. warning:

    Interfaces have supported ``enum`` types since :doc:`Solidity version 0.5.0 <050-breaking-changes>`, make
    sure the pragma version specifies this version as a minimum.

